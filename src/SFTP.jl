module SFTP

export SFTPClient, readdir, download, cd, rm, rmdir, mkdir, mv

include("SFTPImpl.jl")


end # module SFTP
