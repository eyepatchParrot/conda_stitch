# Kakoune Code Project

## Project Overview

Kakoune is a modal code editor that implements Vi's "keystrokes as a text editing language" model. It is written in C++ and features a client-server architecture, allowing multiple clients to connect to the same editing session. Key features include multiple selections, powerful text manipulation primitives, and a strong focus on interactivity.

## Building and Running

### Building

To build Kakoune, you need a C++20 compliant compiler (GCC >= 10.3 or clang >= 11). The project uses a `Makefile` for its build process.

**Build command:**

```bash
bazel build //src:main
```

This will compile the source code and create the `kak` executable in the `src` directory.

### Running the tests

To run the test suite, use the following command:

```bash
make test
```

### Installation

To install Kakoune on your system, you can use the `install` target in the `Makefile`.

**Installation command:**

```bash
make install
```

You can specify the `PREFIX` and `DESTDIR` variables for a custom installation path.

## Development Conventions

### Coding Style

The project has a `doc/coding-style.asciidoc` file that likely contains the coding style guidelines for the project. It is recommended to read this file before contributing to the project.

### Contribution Guidelines

The `CONTRIBUTING` file in the root directory probably contains instructions and guidelines for contributing to the project.

### Client-Server Architecture

Kakoune's client-server architecture is a core concept. The server manages buffers and the overall editing state, while clients are responsible for the user interface. This allows for features like multiple clients on the same editing session. The `src/remote.cc` and `src/remote.hh` files are likely good places to start to understand this architecture.
