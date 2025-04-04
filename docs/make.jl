using SFTPClient
using Documenter, DocumenterVitepress

makedocs(;sitename="Julia SFTPClient Documentation",
    format=DocumenterVitepress.MarkdownVitepress(repo = "github.com/stensmo/SFTPClient.jl"),
    )

deploydocs(; repo="github.com/stensmo/SFTPClient.jl", devbranch="main", push_preview=true)
