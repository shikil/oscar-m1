# Step by step to port Oscar or any JLL to Apple Silicon

1. Install XCode
2. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
3. Install Julia 1.6
    1. Install BinaryBuilder `]add BinaryBuilder`
4. Install Julia [master](https://github.com/JuliaLang/julia)
    1. `git clone https://github.com/JuliaLang/julia`
    2. `make`
5. Copy build_tarballs.jl file from [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)
6. Edit build_tarballs.jl, increase version number and edit dependencies.
    ### Nemo
    1. Build [FLINT_jll](https://github.com/shikil/FLINT_jll.jl)
    2. Build [Antic_jll](https://github.com/shikil/Antic_jll.jl)
    3. Build [Arb_jll](https://github.com/shikil/Arb_jll.jl)
    4. Build [Calcium_jll](https://github.com/shikil/Calcium_jll.jl)
    5. `]dev Nemo`, modify `Project.toml`.

    ### Hecke
    1. `]add Hecke`
    
    ### GAP
    1. Build [Readline_jll](https://github.com/shikil/Readline_jll.jl)
    2. Build libjulia_jll [fail](https://github.com/JuliaPackaging/Yggdrasil/pull/2969) for M1.

    ### Singular
    1. Build libcxxwrap_julia_jll
    2. Build cddlib_jll
    3. Build Singular_jll
    4. Build libsingular_julia_jll
    5. Build lib4ti2
7. Build `julia --color=yes build_tarballs.jl --verbose aarch64-apple-darwin --deploy=repo`
8. If error, goto 6.
9. Run test

| Test      | Julia 1.6.1 | Julia 1.7.0-DEV
| --- | ---: | ---: |
Test Nemo |     2:11.56 | 1:48.19
