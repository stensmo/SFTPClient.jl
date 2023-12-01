module SFTPClient

export SFTP, readdir, download,upload, cd, rm, rmdir, mkdir, mv, sftpstat, SFTPStatStruct

include("SFTPImpl.jl")


end # module SFTPClient
