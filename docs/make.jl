using SFTPClient
using Documenter, DocumenterVitepress


pages = [
    "SFTPClient.jl" => "index.md",
    "API" => "api.md",
    "Troubleshooting" => "troubleshooting.md",
]


makedocs(; 
    sitename = "Julia SFTP Client Documentation", 
    authors = "Erik Stensmo",
    modules = [SFTPClient],
    warnonly = true,
    checkdocs=:all,
    format=DocumenterVitepress.MarkdownVitepress(
        repo = "github.com/stensmo/SFTPClient.jl", # this must be the full URL!
 
    ),
    pages=pages,
)



   

deploydocs(; repo="github.com/stensmo/SFTPClient.jl")
