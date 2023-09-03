using Documenter
using SFTPClient

makedocs(sitename="Julia SFTPClient Documentation ")

deploydocs(
    repo = "github.com/stensmo/SFTPClient.jl.git",
)