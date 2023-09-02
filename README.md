# Julia SFTP Client 
Package for working with SFTP in Julia. Built on Downloads.jl, but in my opinion much easier to use. Downloads.jl is in turn based on Curl. 

The SFTP client supports username/password as well as certificates for authentication. 

The following methods are supported: readdir, download, upload, cd, rm, rmdir, mkdir, mv

___Note: You must first use your local sftp client to set up certificates___
This is done in Windows by using Command Line (cmd.exe) or Windows PowerShell. in Linux use your favorite shell. 
Execute "sftp myuser@siteIwantToConnectTo.com" and acccept any certificates. After this you should be able to connect via the Julia SFTP Client. 

If you are unfortunate that your computer generated a Ed25519 key in the previous step, then it is much harder since Ed25519 won't currently work. ecdsa-sha2-nistp256 will work. Check your known hosts file 
On windows it should be in C:\Users\{your_user}\.ssh

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
