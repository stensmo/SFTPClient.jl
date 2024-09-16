module SFTPClient

 @static if VERSION ≥ v"1.11"
  eval(Meta.parse("public SFTP, readdir, download,upload, cd, rm, rmdir, mkdir, mv, sftpstat, SFTPStatStruct, isdir, isfile, filemode, walkdir"))
else
 export SFTP, readdir, download,upload, cd, rm, rmdir, mkdir, mv, sftpstat, SFTPStatStruct, isdir, isfile, filemode, walkdir
end
 
include("SFTPImpl.jl")


end # module SFTPClient
