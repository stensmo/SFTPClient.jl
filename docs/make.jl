using SFTPClient
using Documenter, DocumenterVitepress

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
    pages = [
            "SFTPClient.jl" => "index.md", 
            
        ],
        "api.md",
    ],
    plugins = [bib,],
)



   

deploydocs(; repo="github.com/stensmo/SFTPClient.jl", devbranch="main", push_preview=true)
