load("//stitch:rules.bzl", "recipe", "package")

filegroup(name="stitch", srcs = glob(["**/*"]) + ["//kakoune/src:stitch"] + ["//kakoune/doc:stitch"],
    visibility = ["//visibility:public"],
)

package(
    name = "package",
    data = [],
    package_name = "stitch-kakoune",
    source_path = ".",
    build_requirements = ["bazel", "stitch-workspace", "stitch-src-kakoune"],
    build_script = " ; ".join(["set -x; cd \\$$BUILD_PREFIX/src ; test -f kakoune/BUILD; bazel build //kakoune/src:kakoune",
        "install -d \\$$PREFIX/bin \\$$PREFIX/share/kak/rc \\$$PREFIX/share/kak/colors \\$$PREFIX/share/kak/doc \\$$PREFIX/share/doc/kak \\$$PREFIX/share/man/man1",
        "cp bazel-bin/kakoune/src/kakoune \\$$PREFIX/bin/kak",
        "cd kakoune/src",
        "install -m 0644 ../share/kak/kakrc \\$$PREFIX/share/kak",
        "install -m 0644 ../doc/pages/*.asciidoc \\$$PREFIX/share/kak/doc",
        "cp -r ../rc/* \\$$PREFIX/share/kak/rc",
        "find \\$$PREFIX/share/kak/rc -type f -exec chmod 0644 {} +",
        "[ -e \\$$PREFIX/share/kak/autoload ] || ln -s rc \\$$PREFIX/share/kak/autoload",
        "install -m 0644 ../colors/* \\$$PREFIX/share/kak/colors",
        "install -m 0644 ../README.asciidoc \\$$PREFIX/share/doc/kak",
        "install -m 0644 ../doc/kak.1.gz \\$$PREFIX/share/man/man1",
    ]),
    version="1",
    build_number="0",
    home="https://github.com/mawww/kakoune",
    summary="Modal editor — Faster as in fewer keystrokes — Multiple selections — Orthogonal design",
    license="OTHER",
    license_file="UNLICENSE",
    recipe_maintainer="eyepatchParrot"
)

