# Julia SFTP Client 
Package for working with SFTP in Julia. Built on Downloads.jl, but in my opinion much easier to use. Downloads.jl is in turn based on Curl. 

The SFTP client supports username/password as well as certificates for authentication. 

The following methods are supported: readdir, download, upload, cd, rm, rmdir, mkdir, mv

___Note: You must first use your local sftp client to set up certificates___
This is done in Windows by using Command Line (cmd.exe) or Windows PowerShell. On Linux, use your favorite shell. 
Execute "sftp myuser@siteIwantToConnectTo.com" and acccept any certificates. Note ED25519 fingerprints do not seem to work at the moment. After this you should be able to connect via the Julia SFTP Client. 

If it does not work, check your known_hosts file in your .ssh directory. ED25519 keys do not seem to work.

Examples:
```

    using SFTPClient
    sftp = SFTP("sftp://test.rebex.net/pub/example/", "demo", "password")
    files=readdir(sftp)
    # On Windows, replace this with an appropriate path
    downloadDir="/tmp/"
    SFTPClient.download.(sftp, files, downloadDir=downloadDir)

```
    You can also use it like this:
```
    
    df=DataFrame(CSV.File(SFTPClient.download(sftp, "/mydir/test.csv")))

```
