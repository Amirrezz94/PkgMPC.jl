using PkgMPC
using Documenter

makedocs(;
    modules=[PkgMPC],
    authors="Amirreza Zamani",
    repo="https://github.com/Amirrezz94/PkgMPC.jl/blob/{commit}{path}#L{line}",
    sitename="PkgMPC.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Amirrezz94.github.io/PkgMPC.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Amirrezz94/PkgMPC.jl",
)
