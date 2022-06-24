filegroup(name="kakoune_srcs", srcs = glob(["*.cc", "*.hh"]) + [":version"])

cc_binary(
    name = "kakoune",
    srcs = [":kakoune_srcs"],
    copts = ["-std=c++20"],
    visibility = ["//kakoune:__pkg__"],
)

genrule(
    name = "version",
    outs = [".version.cc"],
    cmd = """printf "%s" 'namespace Kakoune {{ const char* version = "{}"; }}' > $@""".format("unknown"),
)
