module SFTPClient

export SFTP, readdir, download,upload, cd, rm, rmdir, mkdir, mv, sftpstat, SFTPStatStruct, isdir, isfile, filemode

include("SFTPImpl.jl")


end # module SFTPClient
