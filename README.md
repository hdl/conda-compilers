# litex-conda-compilers

Conda build recipes for C compilers needed for LiteX environments.

The C compilers consist of;

| Tool     | Version | Target     | C Library                                            | C Library Version  |
| -------- | ------- | ---------- | ---------------------------------------------------- | ------------------ |
| binutils | 2.32    | Bare metal |                                                      |                    |
| gcc      | 9.1.0   | Bare metal | no C library                                         |                    |
| gcc      | 9.1.0   | Bare metal | [picolibc](https://github.com/keith-packard/picolibc)| WIP                |
| gcc      | 9.1.0   | Bare metal | [newlib](https://sourceware.org/newlib/)             | 3.1.0              |
| gcc      | 9.1.0   | Linux      | [musl](https://musl-libc.org)                        | git ac304227       |
| gdb      | 8.2     | N/A        |                                                      |                    |

The architectures currently supported are;

| Architecture Name | Abbrev    | Soft Core |
| ----------------- | --------- | --------- |
| LatticeMico32     | `lm32`    | [lm32]() |
| RISC-V 32bit      | `rv32`    | [VexRISCV](), [picorv32](), [minvera](), [tiaga?]() |
| RISC-V 64bit      | `rv64`    | [Rocket](), [BlackParrot?]() |
| OpenRISC1000      | `or1k`    | [mor1k]() |
| PowerPC 64bit     | `ppc64le` | [Microwatt]() |

## Cypress FX2 support

 * sdcc (Current version: 3.5.0)

# Building

This repository is set up to be built by Travis CI, using the GitHub
integration to Travis CI.

See [`.travis.yml`](.travis.yml) for the build configuration given to
Travis CI, and the [`.travis`](.travis) directory for scripts referenced.

The Travis CI output can be found on the https://travis-ci.org/ for the
GitHub account and GitHub repository.  For instance, for the main:

https://github.com/timvideos/conda-hdmi2usb-packages

GitHub repository, the Travis CI results can be seen at:

https://travis-ci.org/timvideos/conda-hdmi2usb-packages

On a successful build in the `timvideos` Travis CI, the resulting packages
are uploaded to:

https://anaconda.org/TimVideos/repo

and can be installed with:

```
conda install --channel "TimVideos" package
```

These packages are mostly used by
[`litex-buildenv`](https://github.com/timvideos/litex-buildenv).

## Building via Travis CI in your own repository

If you [enable Travis CI on your GitHub
fork](https://travis-ci.com/getting_started) of `conda-hdmi2usb-packages`
then your Travis CI results will be at:

```
https://travis-ci.org/${GITHUB_USER}/conda-hdmi2usb-packages
```

Since the repository includes `.travis.yml` and all the other Travis CI
setup, you should just need to turn on the Travis CI integration at GitHub,
and push changes to your GitHub repo, to trigger a Travis CI build, then
watch the https://travis-ci.org/ site for the build progress.

A full build of everything will take the Travis CI infrastructure a few
hours if it all builds successfully.

## Common Travis CI build failures

If the build fails, see the [common Travis CI build
problems](https://docs.travis-ci.com/user/common-build-problems/)
for assistance investigating the issues.  Common issues with this
repository include package dependencies (eg, where Conda has changed),
output log file size (Travis CI has a 4MB maximum, and some package
builds like `gcc` generate a *lot* of output), and builds timing out
(either for maximum time allocation, or for ["no output" for more than
10 minutes](https://docs.travis-ci.com/user/common-build-problems/#build-times-out-because-no-output-was-received)).

## Testing conda builds locally

It is recommend to build these packages in a fresh disposable environment
such as a clean container (Docker, Podman etc.).
While the goal is for the conda environment to be totally self contained,
there is a constant battle to make sure this happens.

The commands from the following subsections were tested to be enough to build
a package in a clean container based on `ubuntu` (`16.04`-`20.04`) or `debian`
(`8`-`10`) Docker image.

### Prerequisites

Apart from cloning this repository to a local directory, the following
prerequisites are required:
* [Git](https://git-scm.com/),
* Conda installed and initialized, e.g., using
[Miniconda](https://docs.conda.io/en/latest/miniconda.html)
(which includes self contained versions of the required *python3* with
*pip* and *setuptools* tooling),
* [conda-build-prepare](https://github.com/litex-hub/conda-build-prepare).

On Debian and Ubuntu, these requirements can be satisfied using the following
commands:

<!-- name="install-prerequisites" -->
```bash
# Install git and wget (might require using `sudo`)
apt-get update
apt-get install -y git wget

# Download Miniconda and install in CONDA_PATH
CONDA_PATH=~/conda
wget -c https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -p $CONDA_PATH -b -f

# Initialize Conda in the shell
eval "$("$CONDA_PATH/bin/conda" "shell.bash" 'hook' 2> /dev/null)"

# Install `conda-build-prepare`
python3 -m pip install git+https://github.com/litex-hub/conda-build-prepare@v0.1.1#egg=conda-build-prepare

# Clone the `conda-compilers` repository
git clone https://github.com/hdl/conda-compilers.git
cd conda-compilers
```

### Required environment variables

Some recipes require exporting additional environment variables.
Such variables must be set before preparing the recipe, which is done
with one of the commands from the next subsection.

Currently required additional environment variables are:
* `TOOLCHAIN_ARCH` (by: `binutils`, `gcc/*`, `gdb` and `toolchain/linux-musl`
recipes) – must contain a supported architecture name, ie. one of these:
  * `lm32` (excluding `gcc/linux-musl` and `toolchain/linux-musl` recipes),
  * `or1k`,
  * `ppc64le` (only `binutils` and `gcc/linux-musl` recipes),
  * `riscv32`,
  * `riscv64`,
  * `sh`.

The `DATE_NUM` and `DATE_STR` environment variables are required by the most of
this repository's recipes.
Values of these variables are commonly used as `build/number` and
`build/string` keys in the recipes.

If the `DATE_STR` hasn't been set in the environment then it is set during the
preparation based:
* on the latest commit's committer date if the recipe belongs to a git
  repository,
* on the latest file modification date after checking all recipe files
  otherwise,
using UTC timezone and `%Y%m%d_%H%M%S` time format, e.g., `20210216_155420`.

The `DATE_NUM` is always automatically set with all `DATE_STR` digits.
In case of the aforementioned `DATE_STR` example, `20210216155420` would be
used as the `DATE_NUM` value.

### Preparing and building the package

After getting all prerequisites and setting the required variables, it is
recommended to prepare the recipe with *conda-build-prepare* before building,
as it gives you the advantages described [on the tool's GitHub
page](https://github.com/litex-hub/conda-build-prepare).
Since it's also used within the CI, the locally built packages will be much
more similar to the ones built by the CI workflow.

#### Preparing the recipe with *conda-build-prepare*

The *conda-build-prepare* is a Python module with a CLI.
Its calling signature is:
```
python3 -m conda_build_prepare
[-h]
[--channels CHANNEL [CHANNEL ...]]
[--packages PACKAGE [PACKAGE ...]]
--dir DIRECTORY
RECIPE
```

The required arguments are:
* `--dir DIRECTORY` – the path for a new directory that will be created with
  output files,
* `RECIPE` – the path to the recipe corresponding to the package chosen to be
  built.

To build a package similarly to how the packages are built in the CI it is
recommended to pass the following optional arguments:
* `--channels litex-hub` – to search for build dependencies in the LiteX-Hub
  channel in addition to the recipe-specific channels (from its `condarc` file),
* `--packages python=3.7` – to use the same versions of
  packages that influence building as in the CI.

After preparing, the output `DIRECTORY` will contain subdirectories:
* `conda-env` with a clean Conda environment to host the build process,
* `git-repos` with source git repositories cloned and slightly adjusted,
* `recipe` with an adjusted recipe (locked requirements, version set etc.).

More details can be found on [the *conda-build-prepare*
GitHub page](https://github.com/litex-hub/conda-build-prepare).

#### Building the package

To build the package using the prepared subdirectories:
* activate the Conda environment from `DIRECTORY/conda-env`,
* run `conda-build` tool with `DIRECTORY/recipe`.

#### Script to prepare the recipe and build the package

All of the following commands are meant to be run from the repository root.

If the provided commands are to be used unmodified, it is important to first
set the `RECIPE_PATH` variable with the proper recipe's path to build the
chosen package and the variables mentioned in the previous subsection, if the
recipe requires such.
By default, the `binutils-riscv64` package will be built.

The `PREPARED_RECIPE_OUTPUTDIR` variable sets the directory that will be
created with the already described `conda-build-prepare`'s output
subdirectories.
By default, the `cbp-outdir` will be created in the repository root.

<!-- name="prepare-and-build" -->
```bash
# Some defaults for the variables used in subsequent commands
PREPARED_RECIPE_OUTPUTDIR=${PREPARED_RECIPE_OUTPUTDIR:-cbp-outdir}
if [ ! -v RECIPE_PATH ]; then
        RECIPE_PATH=binutils
        # TOOLCHAIN_ARCH is required by the `binutils` recipe
        export TOOLCHAIN_ARCH=riscv64
fi

# Prepare the RECIPE with `conda-build-prepare`
ADDITIONAL_PACKAGES="python=3.7"
python3 -m conda_build_prepare               \
            --channels litex-hub             \
            --packages $ADDITIONAL_PACKAGES  \
            --dir $PREPARED_RECIPE_OUTPUTDIR \
            $RECIPE_PATH

# Activate prepared environment where `conda build` will be run
conda activate $PREPARED_RECIPE_OUTPUTDIR/conda-env

# Build the package
conda build $PREPARED_RECIPE_OUTPUTDIR/recipe
```

### Additional information

Expect packages like `binutils` to take 3-5 minutes to build, packages
like `gcc/nostdc` to take 10-15 minutes to build, and packages like
`gcc/newlib` to take 25-40 minutes to build, on a relatively fast
build system (eg, SSD, i7, reasonable amount of RAM).  Beware that
`gcc/newlib` wants to see `gcc/nostdc` *of the same version* already
installed before it will build; this means that `gcc/newlib` is
non-trivial to build individually.

To build one architecture of tools, without any cleanup will need a
VM with maybe 12-15GiB of space available (a 10GiB disk image is not
quite big enough). Building more architectures at once will need more
disk space.

**NOTE**: By preference only packages built by Travis CI should be
uploaded to the Anaconda repository, so that the externally visible
packages have consistent package versions (and do not conflict).  But
it can be useful to build locally to debug `conda-build` config issues
without waiting for a full Travis CI cycle.
