load("@rules_rust//rust:toolchain.bzl", "rust_toolchain")
# exports_files(["./rules_rust.tgz", "./tinyjson.tgz"])

filegroup(
    name = "rustc",
    srcs = ["bin/rustc"],
    visibility = ["//visibility:public"],
)


filegroup(
    name = "rustc_srcs",
    srcs = glob(["lib/rustlib/src/**/*"], allow_empty=True),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rustc_lib",
    srcs = glob(
        [
            "bin/*.dylib",
            "lib/*.dylib",
            "lib/rustlib/x86_64-apple-darwin/codegen-backends/*.dylib",
            "lib/rustlib/x86_64-apple-darwin/bin/rust-lld",
            "lib/rustlib/x86_64-apple-darwin/lib/*.dylib",
        ],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "rustdoc",
    srcs = ["bin/rustdoc"],
    visibility = ["//visibility:public"],
)
load("@rules_rust//rust:toolchain.bzl", "rust_toolchain")

filegroup(
    name = "clippy_driver_bin",
    srcs = ["bin/clippy-driver"],
    visibility = ["//visibility:public"],
)
load("@rules_rust//rust:toolchain.bzl", "rust_toolchain")

filegroup(
    name = "cargo",
    srcs = ["bin/cargo"],
    visibility = ["//visibility:public"],
)
load("@rules_rust//rust:toolchain.bzl", "rust_toolchain")

filegroup(
    name = "rustfmt_bin",
    srcs = ["bin/rustfmt"],
    visibility = ["//visibility:public"],
)

sh_binary(
    name = "rustfmt",
    srcs = [":rustfmt_bin"],
    visibility = ["//visibility:public"],
)

load("@rules_rust//rust:toolchain.bzl", "rust_stdlib_filegroup")

rust_stdlib_filegroup(
    name = "rust_lib-x86_64-apple-darwin",
    srcs = glob(
        [
            "lib/rustlib/x86_64-apple-darwin/lib/*.rlib",
            "lib/rustlib/x86_64-apple-darwin/lib/*.dylib",
            "lib/rustlib/x86_64-apple-darwin/lib/*.a",
            "lib/rustlib/x86_64-apple-darwin/lib/self-contained/**",
        ],
        # Some patterns (e.g. `lib/*.a`) don't match anything, see https://github.com/bazelbuild/rules_rust/pull/245
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)
rust_toolchain(
    name = "toolchain_for_x86_64-apple-darwin_impl",
    rust_doc = "//tools/rust:rustdoc",
    rust_std = "//tools/rust:rust_lib-x86_64-apple-darwin",
    rustc = "//tools/rust:rustc",
    rustfmt = "//tools/rust:rustfmt_bin",
    cargo = "//tools/rust:cargo",
    clippy_driver = "//tools/rust:clippy_driver_bin",
    rustc_lib = "//tools/rust:rustc_lib",
    rustc_srcs = "//tools/rust:rustc_srcs",
    binary_ext = "",
    staticlib_ext = ".a",
    dylib_ext = ".dylib",
    stdlib_linkflags = ["-lSystem", "-lresolv"],
    os = "darwin",
    default_edition = "2018",
    exec_triple = "x86_64-apple-darwin",
    target_triple = "x86_64-apple-darwin",
    visibility = ["//visibility:public"],
)

load("@rules_rust//rust:toolchain.bzl", "rust_stdlib_filegroup")

rust_stdlib_filegroup(
    name = "rust_lib-wasm32-unknown-unknown",
    srcs = glob(
        [
            "lib/rustlib/wasm32-unknown-unknown/lib/*.rlib",
            "lib/rustlib/wasm32-unknown-unknown/lib/*.wasm",
            "lib/rustlib/wasm32-unknown-unknown/lib/*",
            "lib/rustlib/wasm32-unknown-unknown/lib/self-contained/**",
        ],
        # Some patterns (e.g. `lib/*.a`) don't match anything, see https://github.com/bazelbuild/rules_rust/pull/245
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)
rust_toolchain(
    name = "toolchain_for_wasm32-unknown-unknown_impl",
    rust_doc = "//tools/rust:rustdoc",
    rust_std = "//tools/rust:rust_lib-wasm32-unknown-unknown",
    rustc = "//tools/rust:rustc",
    rustfmt = "//tools/rust:rustfmt_bin",
    cargo = "//tools/rust:cargo",
    clippy_driver = "//tools/rust:clippy_driver_bin",
    rustc_lib = "//tools/rust:rustc_lib",
    rustc_srcs = "//tools/rust:rustc_srcs",
    binary_ext = ".wasm",
    staticlib_ext = "",
    dylib_ext = ".wasm",
    stdlib_linkflags = [],
    os = "unknown",
    default_edition = "2018",
    exec_triple = "x86_64-apple-darwin",
    target_triple = "wasm32-unknown-unknown",
    visibility = ["//visibility:public"],
)

load("@rules_rust//rust:toolchain.bzl", "rust_stdlib_filegroup")

rust_stdlib_filegroup(
    name = "rust_lib-wasm32-wasi",
    srcs = glob(
        [
            "lib/rustlib/wasm32-wasi/lib/*.rlib",
            "lib/rustlib/wasm32-wasi/lib/*.wasm",
            "lib/rustlib/wasm32-wasi/lib/*",
            "lib/rustlib/wasm32-wasi/lib/self-contained/**",
        ],
        # Some patterns (e.g. `lib/*.a`) don't match anything, see https://github.com/bazelbuild/rules_rust/pull/245
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)
rust_toolchain(
    name = "toolchain_for_wasm32-wasi_impl",
    rust_doc = "//tools/rust:rustdoc",
    rust_std = "//tools/rust:rust_lib-wasm32-wasi",
    rustc = "//tools/rust:rustc",
    rustfmt = "//tools/rust:rustfmt_bin",
    cargo = "//tools/rust:cargo",
    clippy_driver = "//tools/rust:clippy_driver_bin",
    rustc_lib = "//tools/rust:rustc_lib",
    rustc_srcs = "//tools/rust:rustc_srcs",
    binary_ext = ".wasm",
    staticlib_ext = "",
    dylib_ext = ".wasm",
    stdlib_linkflags = [],
    os = "wasi",
    default_edition = "2018",
    exec_triple = "x86_64-apple-darwin",
    target_triple = "wasm32-wasi",
    visibility = ["//visibility:public"],
)

toolchain(
    name = "toolchain_for_x86_64-apple-darwin",
    exec_compatible_with = ["@platforms//cpu:x86_64", "@platforms//os:osx"],
    target_compatible_with = ["@platforms//cpu:x86_64", "@platforms//os:osx"],
    toolchain = "//tools/rust:toolchain_for_x86_64-apple-darwin_impl",
    toolchain_type = "@rules_rust//rust:toolchain",
)

toolchain(
    name = "toolchain_for_wasm32-unknown-unknown",
    exec_compatible_with = ["@platforms//cpu:x86_64", "@platforms//os:osx"],
    target_compatible_with = ["@rules_rust//rust/platform/cpu:wasm32", "@rules_rust//rust/platform/os:unknown"],
    toolchain = "//tools/rust:toolchain_for_wasm32-unknown-unknown_impl",
    toolchain_type = "@rules_rust//rust:toolchain",
)

toolchain(
    name = "toolchain_for_wasm32-wasi",
    exec_compatible_with = ["@platforms//cpu:x86_64", "@platforms//os:osx"],
    target_compatible_with = ["@rules_rust//rust/platform/cpu:wasm32", "@rules_rust//rust/platform/os:wasi"],
    toolchain = "//tools/rust:toolchain_for_wasm32-wasi_impl",
    toolchain_type = "@rules_rust//rust:toolchain",
)
