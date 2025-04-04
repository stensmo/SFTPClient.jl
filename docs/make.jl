using SFTPClient
using Documenter, DocumenterVitepress

makedocs(;sitename="Julia SFTPClient Documentation",
    format=DocumenterVitepress.MarkdownVitepress(repo = "github.com/stensmo/SFTPClient.jl.git"),
    )

