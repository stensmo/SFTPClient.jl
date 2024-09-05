# Julia SFTP Client 
Package for working with SFTP in Julia. Built on Downloads.jl, but in my opinion much easier to use. Downloads.jl is in turn based on Curl. 

The Julia SFTP client supports username/password as well as certificates for authentication. 

The following methods are supported: readdir, download, upload, cd, rm, rmdir, mkdir, mv, sftpstat (like stat)
 

Examples:
```

    using SFTPClient
    sftp = SFTP("sftp://test.rebex.net/pub/example/", "demo", "password")
    files=readdir(sftp)
    # On Windows, replace this with an appropriate path
    downloadDir="/tmp/"
    SFTPClient.download.(sftp, files, downloadDir=downloadDir)

    statStructs = sftpstat(sftp)

```
   
  
    
```
    #You can also use it like this
    df=DataFrame(CSV.File(SFTPClient.download(sftp, "/mydir/test.csv")))
    # For certificates you can use this for setting it up
    sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser")
    # Since 0.3.8 you can also do this
    sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser", "cert.pub", "cert.pem") # Assumes cert.pub and cert.pem is in your current path
    # The cert.pem is your certificate (private key), and the cert.pub can be obtained from the private key.
    # ssh-keygen -y  -f ./cert.pem. Save the output into "cert.pub". 

```

[API Documentation](https://stensmo.github.io/SFTPClient.jl/stable/reference/)

# Troubleshooting

If you get: RequestError: Failure establishing ssh session: -5, Unable to exchange encryption keys while requesting... Try and upgrade to Julia 1.9.4. It seems to be a bug in an underlying library.





