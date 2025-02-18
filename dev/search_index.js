var documenterSearchIndex = {"docs":
[{"location":"troubleshooting/#Troubleshooting","page":"Troubleshooting","title":"Troubleshooting","text":"","category":"section"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"If you get: RequestError: Failure establishing ssh session: -5, Unable to exchange encryption keys while requesting... Try and upgrade to Julia 1.9.4. It seems to be a bug in an underlying library.","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"If it does not work, check your known_hosts file in your .ssh directory. ED25519 keys do not seem to work.","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"Use the ssh-keyscan tool: From command line, execute: ssh-keyscan [hostname]. Add the ecdsa-sha2-nistp256 line to your knownhosts file. This file is located in your .ssh-directory. This is directory is located in C:\\Users\\{youruser}\\.ssh on Windows and ~/.ssh on Linux.","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"___Note: Setting up certificate authentication___","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"To set up certificate authentication, create the certificates in the ~/.ssh/idrsa and ~/.ssh/idrsa.pub files. On Windows these are located in C:\\Users\\{your user}\\.ssh. ","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"Then use the function  sftp = SFTP(\"sftp://mysitewhereIhaveACertificate.com\", \"myuser\") to create a SFTP type.","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"Example files","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"___in \"known_hosts\"___ mysitewhereIhaveACertificate.com ssh-rsa sdsadxcvacvljsdflsajflasjdfasldjfsdlfjsldfj","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"___in \"id_rsa\"___","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"––-BEGIN RSA PRIVATE KEY––- ..... cu1sTszTVkP5/rL3CbI+9rgsuCwM67k3DiH4JGOzQpMThPvolCg=","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"––-END RSA PRIVATE KEY––-","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"___in id_rsa.pub___ ssh-rsa AAAAB3...SpjX/4t Comment here","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"After setting up the files, test using your local sftp client:","category":"page"},{"location":"troubleshooting/","page":"Troubleshooting","title":"Troubleshooting","text":"ssh myuser@mysitewhereIhaveACertificate.com","category":"page"},{"location":"reference/#SFTPClient-API-Documentation","page":"SFTPClient API Documentation","title":"SFTPClient API Documentation","text":"","category":"section"},{"location":"reference/","page":"SFTPClient API Documentation","title":"SFTPClient API Documentation","text":"Modules = [SFTPClient]\nOrder   = [:function, :type]","category":"page"},{"location":"reference/#Base.Filesystem.cd-Tuple{SFTPClient.SFTP, AbstractString}","page":"SFTPClient API Documentation","title":"Base.Filesystem.cd","text":"cd(sftp::SFTP, dir::AbstractString)\n\nChange the directory for the SFTP client.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.Filesystem.filemode-Tuple{SFTPClient.SFTPStatStruct}","page":"SFTPClient API Documentation","title":"Base.Filesystem.filemode","text":"Base.isdir(st::SFTPStatStruct) \n\nGet the filemode of the directory\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.Filesystem.isdir-Tuple{SFTPClient.SFTPStatStruct}","page":"SFTPClient API Documentation","title":"Base.Filesystem.isdir","text":"Base.isdir(st::SFTPStatStruct) \n\nTest if st is a directory\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.Filesystem.isfile-Tuple{SFTPClient.SFTPStatStruct}","page":"SFTPClient API Documentation","title":"Base.Filesystem.isfile","text":"Base.isfile(st::SFTPStatStruct) \n\nTest if st is a file\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.Filesystem.islink-Tuple{SFTPClient.SFTPStatStruct}","page":"SFTPClient API Documentation","title":"Base.Filesystem.islink","text":"islink(path) -> Bool\n\nReturn true if path is a symbolic link, false otherwise.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.Filesystem.mkdir-Tuple{SFTPClient.SFTP, AbstractString}","page":"SFTPClient API Documentation","title":"Base.Filesystem.mkdir","text":"mkdir(sftp::SFTP, dir::AbstractString)\n\nCreate a directory\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.Filesystem.mv-Tuple{SFTPClient.SFTP, AbstractString, AbstractString}","page":"SFTPClient API Documentation","title":"Base.Filesystem.mv","text":"mv(     sftp::SFTP,     oldname::AbstractString,     newname::AbstractString; )\n\nMove, i.e., rename the file. \n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.Filesystem.readdir","page":"SFTPClient API Documentation","title":"Base.Filesystem.readdir","text":"readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)\n\nReads the current directory. Returns a vector of Strings just like the regular readdir function.\n\n\n\n\n\n","category":"function"},{"location":"reference/#Base.Filesystem.rm-Tuple{SFTPClient.SFTP, AbstractString}","page":"SFTPClient API Documentation","title":"Base.Filesystem.rm","text":"rm(sftp::SFTP, file_name::AbstractString)\n\nRemove (delete) the file\n\n\n\n\n\n","category":"method"},{"location":"reference/#SFTPClient.download","page":"SFTPClient API Documentation","title":"SFTPClient.download","text":"SFTPClient.download(     sftp::SFTP,     file_name::AbstractString,      output = tempname();downloadDir::Union{String, Nothing}=nothing)\n\n Download a file. You can download it and use it directly, or save it to a file. \n Specify downloadDir if you want to save downloaded files. You can also use broadcasting.\nExample:\n\nsftp = SFTP(\"sftp://test.rebex.net/pub/example/\", \"demo\", \"password\")\nfiles=readdir(sftp)\ndownloadDir=\"/tmp\"\nSFTPClient.download.(sftp, files, downloadDir=downloadDir)\n\nYou can also use it like this:\ndf=DataFrame(CSV.File(SFTPClient.download(sftp, \"/mydir/test.csv\")))\n\n\n\n\n\n","category":"function"},{"location":"reference/#SFTPClient.rmdir-Tuple{SFTPClient.SFTP, AbstractString}","page":"SFTPClient API Documentation","title":"SFTPClient.rmdir","text":"rmdir(sftp::SFTP, dir_name::AbstractString)\n\nRemove (delete) the directory\n\n\n\n\n\n","category":"method"},{"location":"reference/#SFTPClient.sftpstat-Tuple{SFTPClient.SFTP, AbstractString}","page":"SFTPClient API Documentation","title":"SFTPClient.sftpstat","text":"sftpstat(sftp::SFTP, path::AbstractString)\n\nLike Julia stat, but returns a Vector of SFTPStatStructs. Note that you can only run this on directories. Can be used for checking if a file was modified, and much more.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SFTPClient.upload-Tuple{SFTPClient.SFTP, AbstractString}","page":"SFTPClient API Documentation","title":"SFTPClient.upload","text":"upload(sftp::SFTP, file_name::AbstractString)\n\nUpload (put) a file to the server. Broadcasting can be used too. \n\nfiles=readdir() upload.(sftp,files)\n\n\n\n\n\n","category":"method"},{"location":"reference/#SFTPClient.walkdir-Tuple{SFTPClient.SFTP, Any}","page":"SFTPClient API Documentation","title":"SFTPClient.walkdir","text":"SFTPClient.walkdir(sftp::SFTP, root; topdown=true, follow_symlinks=false, onerror=throw)\nReturn an iterator that walks the directory tree of a directory.\nThe iterator returns a tuple containing `(rootpath, dirs, files)`.\n\n\n# Examples\n```julia\nfor (root, dirs, files) in walkdir(sftp, \".\")\n    println(\"Directories in $root\")\n    for dir in dirs\n        println(joinpath(root, dir)) # path to directories\n    end\n    println(\"Files in $root\")\n    for file in files\n        println(joinpath(root, file)) # path to files\n    end\nend\n```\n\n\n\n\n\n","category":"method"},{"location":"reference/#SFTPClient.SFTP-NTuple{4, AbstractString}","page":"SFTPClient API Documentation","title":"SFTPClient.SFTP","text":"SFTP(url::AbstractString, username::AbstractString, publickeyfile::AbstractString, privatekeyfile::AbstractString;disableverifypeer=false, disableverifyhost=false, verbose=false)\n\nCreates a new SFTP client using certificate authentication, and keys in the files specified\n\nsftp = SFTP(\"sftp://mysitewhereIhaveACertificate.com\", \"myuser\", \"test.pub\", \"test.pem\")\n\n\n\n\n\n","category":"method"},{"location":"reference/#SFTPClient.SFTP-Tuple{AbstractString, AbstractString, AbstractString}","page":"SFTPClient API Documentation","title":"SFTPClient.SFTP","text":"SFTP(url::AbstractString, username::AbstractString, password::AbstractString;createknownhostsentry=true, disableverifypeer=false, disableverify_host=false)\n\nCreates a new SFTP Client: url: The url to connect to, e.g., sftp://mysite.com username: The username to use password: The users password createknownhosts_entry: Automatically create an entry in known hosts\n\nExample: sftp = SFTP(\"sftp://test.rebex.net\", \"demo\", \"password\")\n\n\n\n\n\n","category":"method"},{"location":"reference/#SFTPClient.SFTP-Tuple{AbstractString, AbstractString}","page":"SFTPClient API Documentation","title":"SFTPClient.SFTP","text":"SFTP(url::AbstractString, username::AbstractString;disableverifypeer=false, disableverifyhost=false)\n\nCreates a new SFTP client using certificate authentication. \n\nsftp = SFTP(\"sftp://mysitewhereIhaveACertificate.com\", \"myuser\")\n\nNote! You must provide the username for this to work. \n\nBefore using this method, you must set up your certificates in ~/.ssh/idrsa and ~/.ssh/idrsa.pub\n\nOf course, the host need to be in the known_hosts file as well. \n\nTest using your local client first: ssh myuser@mysitewhereIhaveACertificate.com\n\nSee other method if you want to use files not in ~/ssh/\n\n\n\n\n\n","category":"method"},{"location":"#Julia-SFTP-Client","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"","category":"section"},{"location":"","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"An SFTP Client for Julia.","category":"page"},{"location":"","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"A julia package for communicating with SFTP Servers, supporting username and password, or certificate authentication. ","category":"page"},{"location":"#SFTPClient-Features","page":"Julia SFTP Client","title":"SFTPClient Features","text":"","category":"section"},{"location":"","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"- readdir\n- download\n- upload \n- cd\n- walkdir\n- rm \n- rmdir\n- mkdir\n- mv\n- sftpstat (like stat, but more limited)","category":"page"},{"location":"#SFTPClient-Installation","page":"Julia SFTP Client","title":"SFTPClient Installation","text":"","category":"section"},{"location":"","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"Install by running:","category":"page"},{"location":"","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"import Pkg;Pkg.add(\"SFTPClient\")","category":"page"},{"location":"#SFTPClient-Examples","page":"Julia SFTP Client","title":"SFTPClient Examples","text":"","category":"section"},{"location":"","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"\n    using SFTPClient\n    sftp = SFTP(\"sftp://test.rebex.net/pub/example/\", \"demo\", \"password\")\n    files=readdir(sftp)\n    # On Windows, replace this with an appropriate path\n    downloadDir=\"/tmp/\"\n    SFTPClient.download.(sftp, files, downloadDir=downloadDir)\n","category":"page"},{"location":"","page":"Julia SFTP Client","title":"Julia SFTP Client","text":"    #You can also use it like this\n    df=DataFrame(CSV.File(SFTPClient.download(sftp, \"/mydir/test.csv\")))\n\n    # For certificate authentication, you can do this (since 0.3.8)\n    sftp = SFTP(\"sftp://mysitewhereIhaveACertificate.com\", \"myuser\", \"cert.pub\", \"cert.pem\")\n   \n    # The cert.pem is your certificate (private key), and the cert.pub can be obtained from the private # key as following: ssh-keygen -y  -f ./cert.pem. Save the output into \"cert.pub\". \n","category":"page"}]
}
