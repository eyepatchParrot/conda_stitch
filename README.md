This repo is not affiliated with Anaconda or Conda Forge.

It is a placeholder for a project to build on related technology.

The goal is to use conda to stitch together a development environment
which has a single worktree / workspace.

- Conda packages to manage your editor [kakoune-conda](#kakoune-conda)

# kakoune-conda
By making all plugins conda packages you can handle dependency management
of both plugins and tools. With noactivate-env, simple conda environments
don't need to be activated to work as expected. With kakoune-amalgamate,
speed is much improved on slow file systems such as nfs by combining
into a single file. This refreshes any time a package is installed,
such as a new plugin. If you needed additional behavior on installing
a package, you can use amalgamate as a reference.

I've included andreyorst/fzf.kak as an example here.
