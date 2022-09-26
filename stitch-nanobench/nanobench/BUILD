_hdrs = ["nanobench.h"]

cc_library(
    name = "nanobench",
    hdrs = _hdrs,
    srcs = ["libnanobench.a"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "isystem",
    srcs = ["libnanobench.a"],
    hdrs = [".include/{}".format(hdr) for hdr in _hdrs],
    includes = [".include"],
    visibility = ["//visibility:public"],
)
