This repo is not affiliated with Anaconda or Conda Forge.

It is a placeholder for a project to build on related technology.

Stitch aims to improve the developer experience for programming anywhere in your dependency graph in any language on any system and share it with others.
Get started on a new project by specifying your language and adding dependencies as you go.
Capture those requirements in a recipe and if your friends can install your package, then they can get started changing code anywhere.

Stitch does this by composing Conda with Bazel to stitch together a development environment which integrates the conda environment with the build configuration.

Here's what this could look like.
My favorite text editor is Kakoune, and it uses lightweight plugins which compose other programs on your system like `fzf`.
So, a plugin `kak-fzf` lets you split your `tmux` pane to let you search your project accelerating that search with `ripgrep`.
If I come up wih an idea for how I can add new functionality to `kak-fzf` by modifying ripgrep and integrating with `kak-fzf`, stitch sets up a dev environment where my changes can be integrated together and immediately visible.

```sh
# Pseudocode assuming micromamba is installed to ~/micromamba using only existing tooling
micromamba create -n dev stitch-kak-fzf-rg boa && micromamba activate dev # Initialize
cd ~/micromamba/envs/dev/share/stitch && git clone -b stitch stitch/ripgrep/ripgrep.bundle override/ripgrep # Override
... # Edit ripgrep
bazel build --override_repository=ripgrep=$PWD/override ripgrep @stitch_local//:kakoune # Build
$PWD/../bazel-bin/external/stitch_local/bin/kak # Try
boa build override/ripgrep/recipe # Share
```

# Tradeoffs and constraints
Stitch needs to provide a quality experience under constrained environments.
Stitch's main offering is to make cross-dependency, multi-language development more pleasant and easier, so if there's a better alternative which is suitable for your environment, you should use that.
If it misses a key environment constraint, then it may as well not exist, so you have to pick what environments you want to make stitch useful for.

1. Primary objectives
  - Compile multiple languages together with merged requirements
  - Make and test changes on separate packages simultaneously
  - Minimize what is observed from the host system
  - Incremental integration bootstraps with impure leveraging of existing software
2. Optimize for
  - Multiple host OS + distro
  - Leverage existing popular solutions
  - Minimize volume of what is relevant for reasoning about compilation, linking, and execution
  - Discoverability of dependency implementations
  - Under-powered hosts

I've included environment constraints separately:
1. No root required. For example, fuse has mixed policies across distros around permissions, and may need to localize everything to a particular directory like home.
2. Works with an airgapped build host
3. Binares are invocable from outside tooling

There are some shortcuts I've taken to accelerate development, but I believe my larger design choices keep viable.
Examples include:
- Multiple OS. Mac development was postponed due to OS updates breaking direct reliance on SDK paths
- Recipe cleanliness including reliance on transitive dependencies and overly-strict version pins. Architecture data of recipes is dirty as well
- Multiple platform targets
- Automation is postponed until the target is more stable

## Multiple languages and merged requirements
Projects which mix different languages have to be extra careful about diamond dependencies.
If a C++ package depends on C and Rust packages, and the Rust package depends on some of the same C packages, those versions have to be synchronized.
So, you need a single source of truth which spans across package managers.
However, writing packages is hard work, so if you can get that single source of truth by integrating into an existing, large ecosystem or ecosystems, you can save yourself a lot of work.

## Building and testing simultaneously
This is supported by allowing multiple repos to be overriden simultaneously with their recipe definitions.

## Minimizing host-dependent behavior
We've been able to minimize a lot of host-dependent behavior by leveraging
Bazel sandboxes to be confident that language toolchains observe very
little which is outside of the conda environment. For example, we know that the glibc which conda-forge ships for gcc 12 is incompatible with our Ubuntu 16.04 CI, so we can isolate ourselves from that.

Since we isolate ourselves from the host, and build in a Bazel sandbox
using packages which are constructed in conda sandboxes, we can have a
lot more confidence that we can stick to reasoning about our environment
and not worry about what issues might be observed from the system.
There are, of course, some exceptions to that at runtime, but building
a portable package can focus on what's in conda.

Unfortunately, stitch currently requires Python installed to the system for Bazel shebangs. Possibly
will go away with newer version of Bazel and with custom shebangs and
alternative is possible, but non-trivial to write.

## Incremental integration
Incremental integration requires that things built by stitch be able to operate with files and programs outside stitch and be used from files and programs outside stitch.
Some tradeoffs have more clear-cut threshold effects. So, while supporting
built binaries with files outside stitch and binaries outside stitch which
use stitch binaries as sub-processes is high return for effort, crossing
those boundaries with linkage hurts ability to reason substantially.

## Leveraging existing solutions
Bazel is chosen as the multiple-OS, multiple-language build system with the most available packages and contributors.
Conda is chosen as the multiple-OS, multiple-language package manager which meets requirements for root and directories.

Conda has good support for working when airgapped. Bazel workspace
definitions are idiomatically written in a way which needs the internet,
but the build system itself works pretty well when airgapped.

## Reasoning
I include reasoning here since its an explicit objective, but it is more meta than many other objectives.
Discoverability is intended to improve reasoning about where to look for broken things or for feature ideas.
Minimizing host observation is intended to reduce what might be broken.

## Discoverability
`$CONDA_ENV/share/stitch` is the starting point for your project, so all other paths are relative to that.
You can find what's already installed under `stitch/` since all those are repositories which are automatically discovered.
New development goes in `override/$MY_NEW_REPO` and is toggled with `.bazelrc.local`
Other installed files go into `rc/` for things like toolchain bazelrc files (which aren't apart of the repository).
So, with those 3 folders, you should get a pretty good view of your stitch dependencies.
However, toolchain dependencies pull in files from the conda environment,
so you can get a more comprehensive view after doing a build by looking
at the automatically generated symlink of `bazel-stitch/` and the structure under `bazel-stitch/external/`.

This discoverability then directly enables developers to override
behavior since each stitch repo ships with the bundle that can be
immediately cloned with both package source code and recipe.

## Under-powered hosts
With buildbuddy support, you can get larger caches and faster build-times, even on low-core VMs.
Since stitch_local works pretty well without an environment activate, you can achieve some workflows even when your environment is on a slow filesystem like NFS
With use of Bazel, current workflows are a bit heavy handed on memory requirements. I suspect that is reactive and degrades gracefully with limited memory requirements, but it is an issue.

# Where is it now?
The latest work is tracked in the branch `bld` which can be used as a local channel for installing conda packages. For example, if it's cloned to `/home/pv/bld`, then its usable with the following `.condarc`
```yaml
# .condarc
channels:
  - /home/pv/bld
  - conda-forge
auto_activate_base: false
channel_priority: strict
```

Currently working:
1. Toolchains for Rust, Python, and C++ which use the conda-forge binaries
2. Integration with buildbuddy for remote cache and build cluster
3. Kakoune uses the C++ toolchain
4. xo and sphinx-build use the Python toolchain
5. Ripgrep uses the Rust toolchain
6. cargo-raze is built using Cargo from the github repo
7. With `stitch_local` on your manpath, path, etc, several binaries work out of the box without needing to activate the environment

Each stitch package is managed as a git repository which ships in a conda package for ease of development on that package.
So, at the moment, this makes finding what's in stitch really opaque.
It's not ready for primetime yet, so that's OK, but to help with some overview, I've included the channel data in this repo as well.

# What didn't work / is missing?
The Kakoune plugins have not been ported to the latest breaking change of stitch. Nor has the majority of the lexy packages that I worked on.

I named my packages from stitch-0.0.X (with some names from the origin dep) to stitch2-0.0.X, and current version is stitch-0.1.X.

## Symlink all the things
Create a Bazel workspace which symlinks from the conda environment into the workspace.
What was nice about this is that is it improved discoverability and reduced the complexity of C++ include paths.
However, you were never going to be able to use existing Bazel toolchain rules with this approach because many of them relied on being top-level in the workspace.
Broadly, this reduced ability to re-use existing Bazel definitions across several packages.
This means maintaining a lot of symlinks, and in order to stay organized, many of these were very relative. Since the toolchains also rely on relative paths, those paths had to be carefully chosen.
Finally, if you wanted to change the behavior of the existing system, doing that without modifying files which were installed by conda was not very clean.
To avoid modifying files, I tried using an activate script to run ninja to detect where your stitched environment was outdated to separate what conda maintained from the user's overrides, but it meant that every conda activate, (made worse by noactivate-env) ran code that could disturb the environment in hard to reason about ways

## Using bazel run
`stitch_local` exists to allow binaries and system libraries to find each other at the expected paths. In particular, since you need runfiles for C++ to find its system libraries, each binary needs to be able to find those libraries.
Getting the system libraries and user binaries to load correctly was brittle, and became much less so when I used Bazel to synthesize a unified namespace
In particular, if you want MANPATH to work correctly, it's much easier to do so if all your manpages are consolidated into the same place
This also helps cases where binaries look for their files on specific relative directories, like kakoune which searches for plugins at `../share/kak`.

## Custom program interpreter
Currently, stitch packages run on an incompatible docker container, so we have good reason to believe that our libc dependencies are pretty isolated.
However, I think that they still rely on the program interpreter. A constraint from Linux as it stands today is that the program interpreter has to be at an absolute path which is hard-coded into the executable.
Across some glibc upgrades, this creates problems since some program interpreters don't support newer glibcs iirc.
Because this has to be an absolute path, making it relative to the conda environment is hard, in particular when building new packages which are in a totally new directory tree.
I think it would be doable to add the program interpreter into `stitch_local` and patchelf it in since conda environments aren't relocatable.

# (Outdated) Infrastructure
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
