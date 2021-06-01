# Step by step to port Oscar or any JLL to Apple Silicon

1. Install XCode
2. Install Julia 1.6
3. Install Julia [master](https://github.com/JuliaLang/julia)
4. Copy build_tarballs.jl file from [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)
5. Fork the jll repository **repo**.
6. Edit file version number and dependencies.
7. Build `julia --color=yes build_tarballs.jl --verbose aarch64-apple-darwin --deploy=repo`
8. If error, goto 5.
