genrule(
    name = "man",
    outs = ["kak.1.gz"],
    srcs = ["kak.1"],
    cmd = "gzip -n -9 -f < $< > $@",
    visibility = ["//kakoune:__pkg__"],
)
