module SFTPClient

 @static if VERSION ≥ v"1.11"
       public SFTP, readdir, download,upload, cd, rm, rmdir, mkdir, mv, sftpstat, SFTPStatStruct, isdir, isfile, filemode, walkdir
end

export SFTP, readdir, download,upload, cd, rm, rmdir, mkdir, mv, sftpstat, SFTPStatStruct, isdir, isfile, filemode, walkdir

include("SFTPImpl.jl")


end # module SFTPClient
