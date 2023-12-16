module SFTPClient

export SFTP, readdir, download,upload, cd, rm, rmdir, mkdir, mv, sftpstat, SFTPStatStruct, isdir, isfile, filemode, walkdir

include("SFTPImpl.jl")


end # module SFTPClient
