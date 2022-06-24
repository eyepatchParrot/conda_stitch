# This is for making a source package.
def recipe(name, data, source_path, package_name, version, build_number, build_requirements, build_script, home, summary, license, license_file, recipe_maintainer):
    native.genrule(
        name = name,
        srcs = data,
        outs = ["recipe.yaml"],
        cmd = """
cat <<EOF > $@
package:
  name: '{package_name}'
  version: '{version}'

source:
  path: {source_path}
  folder: {package_name}

build:
  number: {build_number}
  script: {build_script}

requirements:
  build:
{build_requirements}

about:
  home: '{home}'
  summary: '{summary}'
  license: {license}
  license_file: {license_file}

extra:
  recipe-maintainers:
    - {recipe_maintainer}
EOF
""".format(
        source_path=source_path,
        package_name=package_name,
        version=version,
        build_number=build_number,
        build_requirements="\n".join(["    - {}".format(r) for r in build_requirements]),
        build_script=build_script,
        home=home,
        summary=summary,
        license=license,
        license_file=license_file,
        recipe_maintainer=recipe_maintainer)
    )

# def source_recipe(**kwargs):
#     recipe(
#         build_script="pwd ; find .",
#         **kwargs
#     )

# def builder(name):
#    native.genrule(
#        name = name,
#        outs = [name],
#        cmd = """
#cat <<EOF > $@
#set -x
#export MAMBA_EXE="$$(which micromamba)"
#export MAMBA_ROOT_PREFIX="/home/pv/micromamba";
#eval "$$(micromamba shell hook --shell=bash)"
#micromamba activate stitch
#env
## export CONDA_BLD_PATH=\\$$CONDA_PREFIX/conda-bld
## boa build .
#EOF
#chmod u+x $@
#    """)

def package(name, data, **kwargs):
    recipe(name = "recipe", data=[], **kwargs)
    native.sh_binary(
        name = name,
        srcs = ["//stitch:builder.bash"],
        data = ["recipe"] + data,
    )

# Generate a bash script which when run, builds the package.

# def conda_build(name, recipe):
# export MAMBA_EXE="$$(which micromamba)"
# export MAMBA_ROOT_PREFIX="/home/pv/micromamba";
# eval "$$(micromamba shell hook --shell=bash)"
# micromamba activate stitch
# export CONDA_BLD_PATH=$$(mktemp -d --tmpdir)
# # export CONDA_BLD_PATH=$$PWD/conda-bld
# set -x
# boa build $$(realpath $$(dirname $@))

# Why do you need the source package, can't you use git?
# Generate a recipe for the binary build of the package
# Generate a bash script which, when run, builds the package

#  script: TGZ=\\$$(realpath $$(basename $<)) ; mkdir -p \\$$PREFIX/src/{package_name} ; cd \\$$_ ; tar xf \\$$TGZ
