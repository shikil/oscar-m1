# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg
import Pkg.Types: VersionSpec

# The version of this JLL is decoupled from the upstream version.
# Whenever we package a new upstream release, we initially map its
# version X.Y.Z to X00.Y00.Z00 (i.e., multiply each component by 100).
# So for example version 2.6.3 would become 200.600.300.
#
# Moreover, all our packages using this JLL use `~` in their compat ranges.
#
# Together, this allows us to increment the patch level of the JLL for minor tweaks.
# If a rebuild of the JLL is needed which keeps the upstream version identical
# but breaks ABI compatibility for any reason, we can increment the minor version
# e.g. go from 200.600.300 to 200.601.300.
# To package prerelease versions, we can also adjust the minor version; e.g. we may
# map a prerelease of 2.7.0 to 200.690.000.
#
# There is currently no plan to change the major version, except when upstream itself
# changes its major version. It simply seemed sensible to apply the same transformation
# to all components.

name = "Calcium"
version = v"000.300.001"
upstream_version = v"0.3.0"

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://github.com/fredrik-johansson/calcium/archive/refs/tags/$(upstream_version).tar.gz",
                  "63e8e1ed97d55d045b13bd28d1b7ab1c38239f08acd226866be6233543cb7456"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd calcium*/

if [[ ${target} == *musl* ]]; then
   export CFLAGS=-D_GNU_SOURCE=1
elif [[ ${target} == *mingw* ]]; then
   # /lib is hardcoded in many places
   sed -i -e "s#/lib\>#/$(basename ${libdir})#g" configure
   # MSYS_NT-6.3 is not detected as MINGW
   extraflags=--build=MINGW${nbits}
fi

./configure --prefix=$prefix --disable-static --enable-shared --with-gmp=$prefix --with-mpfr=$prefix --with-flint=$prefix --with-arb=$prefix --with-antic=$prefix ${extraflags}
make -j${nproc}
make install LIBDIR=$(basename ${libdir})
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    LibraryProduct("libcalcium", :libcalcium)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    Dependency(PackageSpec(name="FLINT_jll", url="https://github.com/shikil/FLINT_jll.jl")),
    Dependency(PackageSpec(name="Arb_jll", url="https://github.com/shikil/Arb_jll.jl")),
    Dependency(PackageSpec(name="Antic_jll", url="https://github.com/shikil/Antic_jll.jl")),
    Dependency("GMP_jll", v"6.2.0"),
    Dependency("MPFR_jll", v"4.1.1"),
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
