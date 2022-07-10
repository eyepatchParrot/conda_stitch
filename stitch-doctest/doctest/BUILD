cc_library(
    name = "doctest",
    hdrs = ["doctest.h"],
    defines = [
        "DOCTEST_CONFIG_IMPLEMENTATION_IN_DLL",
        "DOCTEST_CONFIG_NO_UNPREFIXED_OPTIONS",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "angle",
    hdrs = [":doctest/doctest.h"],
    visibility = ["//visibility:public"],
    defines = [
        "DOCTEST_CONFIG_IMPLEMENTATION_IN_DLL",
        "DOCTEST_CONFIG_NO_UNPREFIXED_OPTIONS",
    ],
    includes = ["."],
)
