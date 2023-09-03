using Documenter
using SFTPClient

makedocs(sitename="Documentation")

deploydocs(
    repo = "github.com/stensmo/SFTPClient.jl.git",
)