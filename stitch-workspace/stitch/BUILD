alias(
    name = "platform", 
    actual = "platform_linux",
)

platform(
    name = "platform_linux",
    constraint_values = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:linux",
        "@bazel_tools//tools/cpp:clang",
    ],
    exec_properties = {
        "OSFamily": "Linux",
    },
)

