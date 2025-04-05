using SFTPClient
using Documenter, DocumenterVitepress


pages = [
    "SFTPClient.jl" => "index.md",
    "API" => "api.md",
    "Troubleshooting" => "troubleshooting.md",
]


makedocs(; 
    sitename = "Julia SFTPClient Documentation", 
    authors = "Erik Stensmo",
    modules = [DocumenterVitepress],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/stensmo/SFTPClient.jl", # this must be the full URL!
        devbranch = "master",
        devurl = "dev";
    ),
    draft = false,
    source = "src",
    build = "build",
    pages=pages,
)



   

deploydocs(; repo="github.com/stensmo/SFTPClient.jl", devbranch="main", push_preview=true)
