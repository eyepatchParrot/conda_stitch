load(
    "@bazel_tools//tools/build_defs/repo:utils.bzl",
    "workspace_and_buildfile",
)

def _maybe_archive_impl(ctx):
    if ctx.path(ctx.attr.src).exists:
        ctx.extract(ctx.attr.src, stripPrefix = getattr(ctx.attr, "strip_prefix", ""))

        if not ctx.path("WORKSPACE").exists:
            ctx.file("WORKSPACE", "workspace(name = \"{name}\")\n".format(name = ctx.name))

        if ctx.attr.build_file and ctx.attr.build_file_content:
            ctx.fail("Only one of build_file and build_file_content can be provided.")
        if ctx.attr.build_file:
            ctx.file("BUILD.bazel", ctx.read(ctx.attr.build_file))
        elif ctx.attr.build_file_content:
            ctx.file("BUILD.bazel", ctx.attr.build_file_content)
    else:
        fail("Expected success")
        ctx.file("WORKSPACE", "")

_maybe_archive = repository_rule(
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file=True),
        "strip_prefix": attr.string(
            default = "",
            doc = "A directory prefix to strip from the extracted files.",
        ),
        "requires_rules": attr.label_list(default=[]),
        "build_file": attr.label(
            allow_single_file = True,
            doc =
                "The file to use as the BUILD file for this repository." +
                "This attribute is an absolute label (use '@//' for the main " +
                "repo). The file does not need to be named BUILD, but can " +
                "be (something like BUILD.new-repo-name may work well for " +
                "distinguishing it from the repository's actual BUILD files. " +
                "Either build_file or build_file_content must be specified.",
        ),
        "build_file_content": attr.string(
            doc =
                "The content for the BUILD file for this repository. " +
                "Either build_file or build_file_content must be specified.",
        ),
    },
    implementation = _maybe_archive_impl,
)


def stitch_repositories():
    _maybe_archive(
      name = "bazel_skylib",
      src = "//tools/bazel:bazel_skylib.tgz",
    )
    _maybe_archive(
      name = "rules_rust",
      src = "//tools/rust:rules_rust.tgz",
    )
    _maybe_archive(
      name="rules_rust_tinyjson",
      src = "//tools/rust:tinyjson.tgz",
      build_file = "//tools/rust:BUILD.tinyjson.bazel",
    )

    # _maybe_archive(
    #   name = "rules_python",
    #   src = "//tools/stitch:rules_python.tgz",
    #   strip_prefix = "rules_python-0.9.0",
    # )

    # _maybe_archive(
    #   name = "rules_cc",
    #   src = "//tools/bazel:rules_cc.tgz",
    # )
