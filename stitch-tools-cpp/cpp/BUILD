# Copyright 2016 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load(":cc_toolchain_config.bzl", "cc_toolchain_config")
load("@rules_cc//cc:defs.bzl", "cc_toolchain", "cc_toolchain_suite")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # Apache 2.0

_includes = [
    "lib/gcc/x86_64-conda-linux-gnu/12.1.0/include",
    "x86_64-conda-linux-gnu/include/c++/12.1.0",
    "x86_64-conda-linux-gnu/include/c++/12.1.0/x86_64-conda-linux-gnu",
    "x86_64-conda-linux-gnu/sysroot/usr/include",
    "lib/gcc/x86_64-conda-linux-gnu/12.1.0/include-fixed",
]
_libs = [
    ":lib/libstdc++.so.6",
    ":lib/libgcc_s.so.1",
    ":lib/libstdc++.so",
    ":lib/libgcc_s.so",
]
filegroup(
    name = "headers",
    srcs = glob(["{}/**".format(dir) for dir in _includes]),
)

cc_library(name = "cpp", hdrs = [":headers"], includes = _includes,
    srcs = _libs + [
        ":x86_64-conda-linux-gnu/sysroot/lib/libm.so.6",
        ":x86_64-conda-linux-gnu/sysroot/lib/libc.so.6",
    ],

    data = ["x86_64-conda-linux-gnu/sysroot/lib/ld-linux-x86-64.so.2"],
    # Required or else I get an ld error at runtime.
    linkopts = ["-Wl,-dynamic-linker,$(location :x86_64-conda-linux-gnu/sysroot/lib/ld-linux-x86-64.so.2)"],
)

# Toolchain stuff

cc_library(
    name = "malloc",
)

filegroup(
    name = "empty",
    srcs = [],
)

filegroup(
    name = "cc_wrapper",
    srcs = ["cc_wrapper.sh"],
)

filegroup(
    name = "compiler_deps",
    srcs = glob(["extra_tools/**"], allow_empty = True),
)

# This is the entry point for --crosstool_top.  Toolchains are found
# by lopping off the name of --crosstool_top and searching for
# the "${CPU}" entry in the toolchains attribute.
cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "k8|compiler": ":cc-compiler-k8",
        "k8": ":cc-compiler-k8",
    },
)

filegroup(name = "ar_files", srcs = ["bin/x86_64-conda-linux-gnu-ar"])
filegroup(name = "compiler_files", srcs = [
    "bin/x86_64-conda-linux-gnu-cpp",
    "bin/x86_64-conda-linux-gnu-gcc",
    "bin/cc",
    "x86_64-conda-linux-gnu/bin/ld.gold",
    "libexec/gcc/x86_64-conda-linux-gnu/12.1.0/cc1plus",
    "libexec/gcc/x86_64-conda-linux-gnu/12.1.0/cc1",
    ":headers",
])
filegroup(
    name = "linker_files",
    srcs = _libs + [
        "bin/ld.gold",
        "bin/cc",
        "x86_64-conda-linux-gnu/bin/ld.gold",
        "bin/x86_64-conda-linux-gnu-gcc",
    ] + glob([
        "lib/gcc/x86_64-conda-linux-gnu/12.1.0/*",
        "libexec/gcc/x86_64-conda-linux-gnu/**",
        "x86_64-conda-linux-gnu/sysroot/**",
    ]),
)
filegroup(name = "all_files", srcs = [":ar_files", ":compiler_files", ":linker_files"])

cc_toolchain(
    name = "cc-compiler-k8",
    toolchain_identifier = "local",
    toolchain_config = ":local",
    all_files = ":all_files",
    ar_files = ":ar_files",
    as_files = ":empty",
    compiler_files = ":compiler_files",
    dwp_files = ":empty",
    linker_files = ":linker_files",
    dynamic_runtime_lib = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
    module_map = None,
)

toolchain(name="cc-toolchain-local", toolchain="cc-compiler-k8", toolchain_type = "@bazel_tools//tools/cpp:toolchain_type")

# I'm requiring dependencies of cc_local to declare that because I can't get the linked libraries integrated with the docker sandbox.
cc_toolchain_config(
    name = "local",
    cpu = "k8",
    compiler = "compiler",
    toolchain_identifier = "local",
    host_system_name = "local",
    target_system_name = "local",
    target_libc = "unknown",
    abi_version = "unknown",
    abi_libc_version = "unknown",
    cxx_builtin_include_directories = [],
    tool_paths = {"ar": "bin/x86_64-conda-linux-gnu-ar",
        "ld": "x86_64-conda-linux-gnu/bin/ld.gold",
        # "ld": "bin/ld.gold",
        # "ld": "bin/x86_64-conda-linux-gnu-ld.gold",
        "llvm-cov": "bin/None",
        "cpp": "bin/x86_64-conda-linux-gnu-cpp",
        "gcc": "bin/cc",
        # "gcc": "bin/x86_64-conda-linux-gnu-gcc",
        # "gcc": "bin/cc_wrapper.sh",
        "dwp": "bin/x86_64-conda-linux-gnu-dwp",
        "gcov": "bin/x86_64-conda-linux-gnu-gcov",
        "nm": "bin/x86_64-conda-linux-gnu-nm",
        "objcopy": "bin/x86_64-conda-linux-gnu-objcopy",
        "objdump": "bin/x86_64-conda-linux-gnu-objdump",
        "strip": "bin/x86_64-conda-linux-gnu-strip",
        "cc1plus": "bin/cc1plus",
    },
    compile_flags = ["-U_FORTIFY_SOURCE",
    "-fstack-protector",
    "-Wall",
    "-Wunused-but-set-parameter",
    "-Wno-free-nonheap-object",
    "-fno-omit-frame-pointer"],
    opt_compile_flags = [
        "-g0",
        "-O2",
        "-D_FORTIFY_SOURCE=1",
        "-DNDEBUG",
        "-ffunction-sections",
        "-fdata-sections"
    ],
    dbg_compile_flags = ["-g"],
    # -Wp,-v is useful to debug include paths
    cxx_flags = [
        "-std=c++17",
        # "-Wp,-v", # -v for verbose
    ],
    link_flags = [
        "-fuse-ld=gold",
        "-Wl,-no-as-needed",
        "-Wl,-z,relro,-z,now",
        # "-Wl,-v", # -v for verbose
        # "-B/usr/bin",
        "-pass-exit-codes"
    ],
    link_libs = ["-lstdc++", "-lm"],
    opt_link_flags = ["-Wl,--gc-sections"],
    unfiltered_compile_flags = ["-fno-canonical-system-headers",
    "-Wno-builtin-macro-redefined",
    "-D__DATE__=\"redacted\"",
    "-D__TIMESTAMP__=\"redacted\"",
    "-D__TIME__=\"redacted\""],
    coverage_compile_flags = ["--coverage"],
    coverage_link_flags = ["--coverage"],
    supports_start_end_lib = True,
    # features = ["include_paths_feature"],
)
