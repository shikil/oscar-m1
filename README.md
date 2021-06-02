# Step by step to port Oscar or any JLL to Apple Silicon

1. Install XCode
2. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
3. Install Julia 1.6
    1. Install BinaryBuilder `]add BinaryBuilder`
5. Install Julia [master](https://github.com/JuliaLang/julia)
    1. `git clone https://github.com/JuliaLang/julia`
    2. `make`
7. Copy build_tarballs.jl file from [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)
8. Fork the jll repository **repo**.
9. Edit build_tarballs.jl, increase version number and edit dependencies.
10. Build `julia --color=yes build_tarballs.jl --verbose aarch64-apple-darwin --deploy=repo`
11. If error, goto 5.
