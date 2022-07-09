This repo is not affiliated with Anaconda or Conda Forge.

It is a placeholder for a project to build on related technology.

The goal is to use conda to stitch together a development environment
which has a single worktree / workspace.

- Conda packages to manage your editor [kakoune-conda](#kakoune-conda)
- Run conda without activating [noactivate-env](#noactivate-env)
- Spin up a Bazel environment for Rust ([nushell](#porting-nushell))
- Combine unit tests with slides


# kakoune-conda
By making all plugins conda packages you can handle dependency management
of both plugins and tools. With noactivate-env, simple conda environments
don't need to be activated to work as expected. With kakoune-amalgamate,
speed is much improved on slow file systems such as nfs by combining
into a single file. This refreshes any time a package is installed,
such as a new plugin. If you needed additional behavior on installing
a package, you can use amalgamate as a reference.

I've included andreyorst/fzf.kak as an example here.

# Mutating the conda environment
Since when conda installs packages, it hardlinks the files, when you change a file in your environment, it also changes the file in the central package store, corrupting it.
This means that when you upgrade versions, your changes are preserved in the old packages, but overwritten in the environment, an unpleasant experience, but potentially predictable enough to prepare for.
If your install is isolated, and you're only doing one environment, I wouldn't anticipate major spreading changes. If you `--always-copy`, the central package store is preserved.
I haven't yet looked into whether or not files can be installed without write permissions from a package.
Altogether, not ideal, but potentially survivable.

However, it might be preferable to user fuse to get overlay directories. Conda ships overlayfs-fuse, but that requires fusermount3 to be suid root or to use an unshare to get a separate mount namespace.
An advantage of the FUSE approach is that I can reuse the distri linux software to merge squashfs into an overlay, and package install becomes downloading squashfs.
The update experience here is that the user's changes override the update, but those changes are visible in the upperdir.

# noactivate-env
Conda activate is expensive to do since it launched the conda CLI
to discover the right environment variables to set. This is more
pronounced on slow storage. Additionally, since it hard codes the
shell, adding a new shell is a non-trivial amount of work. Here, I
manually emulate the simple case of setting basic environment
variables, and allow for an escape hatch if it's needed. In case
that doesn't work out, by wrapping the initialize block into a
function, I can turn it on at will without compromising my shell
startup time.

This lets me use nushell with conda packages without writing special
integration.

It works in four parts:
- Escape hatch with a fully activated shell in your PATH as `conda`
- PATH management to the wrapper directories
- On activate (triggered by install), refresh symlinks to reflect state of bin
- env.sh wrapper in a supported shell to wrap execution of the installed executables in an activated shell

See the package for details on activate and env.

```sh
#!/bin/sh
. /Users/pv/conda/etc/profile.d/conda.sh
export CONDA_DEFAULT_ENV=desktop
conda "$@"
```
This ensures lets conda be used from any shell without writing the
functions for it. Since desktop is my default for installing my
main environment, install has the right default here.

`conda` here is a function defined in `conda.sh`, so it is important
that it be called as a function, not `exec` or any alternatives.

```sh
PATH=/Users/pv/conda/envs/desktop/share/noactivate-env/bin:/Users/pv/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin ; export PATH
```

.cargo/bin is needed for now to support cargo-raze due to details it
relies on where it's installed. Other than that, this is a default
setup with the addition of the noactivate-env/bin


# Porting nushell
nushell required setting up a Bazel environment for Rust. One of
my goals was to avoid any internet access while the build is running.
The default mode for Bazel is to take control of downloading tools
and source. Even validated with a checksum, and with options for
alternative mirrors, I don't wnat my build system even trying. So,
instead, I prefill everything needed using conda packages.

After getting the infrastructure setup for Bazel, I needed to port
nushell. The workflow for this starts with cargo vendor, then using
the cargo-raze utility. I iterate on writing definitions for nushell
with fixing issues in generated cargo-raze BUILD files.

## Infrastructure
- stitch-bazel_skylib
- stitch-rust
- stitch-workspace

stitch-workspace uses a global bzl file to detect that toolchains
are installed by conda, and use them if they're available. It's not
fully functional because It always tries to register the toolchain,
so it doesn't succeed in reacting to available toolchains.

I accelerated the generation of the toolchain for stitch-rust by
using rules_rust examples to generate a valid toolchain for my OS,
then modifying the files as needed. It also requires a tinyjson
library, which would form a circular dependency, so I bundle them
separately.

There are parts of `rules_rust` which relies on refering
to itself by name, so I have to make it its own repository. As a
compromise between internet access, reacting to the presence of the
toolchain, and not writing `new_local_repository` manually, the
package installs tarballs which are extracted as a repository for
a build rule.

The reason why reacting to the existing of the toolchain is important
is that the workspace file is a single file, and would otherwise
have to be synchronized rather than clobbered over multiple installs.
An alternative approach might be to use an activate script, but I
prefer to minimize those.

## Cargo raze
We vendor crates as an initial step towards making them conda
packages. After vendoring, the autogenerated build files are sometimes
incomplete, missing data payloads other details that are not encoded
into Cargo.toml, but in the source only. These can be managed by
adding special cases as needed in the main Cargo.toml. It also
generates a crates.bzl which is useful not only for handling most
of the dependencies for each crate, but also getting a head start
on the relationship between crates in the workspace.
