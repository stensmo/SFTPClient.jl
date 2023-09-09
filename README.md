# Julia SFTP Client 
Package for working with SFTP in Julia. Built on Downloads.jl, but in my opinion much easier to use. Downloads.jl is in turn based on Curl. 

The SFTP client supports username/password as well as certificates for authentication. 

The following methods are supported: readdir, download, upload, cd, rm, rmdir, mkdir, mv


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

[API Documentation](https://stensmo.github.io/SFTPClient.jl/dev/)

___Note: Only do this if you have issues___
If it does not work, check your known_hosts file in your .ssh directory. ED25519 keys do not seem to work.

Use the ssh-keyscan tool: From command line, execute: ssh-keyscan -H [hostname],[ip_address]. Add the ecdsa-sha2-nistp256 line to your known_hosts file. This file is located in your .ssh-directory. This is directory is located in C:\Users\\{your_user}\\.ssh on Windows and ~/.ssh on Linux.



___Note: Setting up certificate authentication___

To set up certificate authentication, create the certificates in the ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub files. On Windows these are located in C:\Users\\{your user}\\.ssh. 

Then use the function  sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser") to create a SFTP type.

Example files

___in "known_hosts"___
mysitewhereIhaveACertificate.com ssh-rsa sdsadxcvacvljsdflsajflasjdfasldjfsdlfjsldfj

___in "id_rsa"___

-----BEGIN RSA PRIVATE KEY-----
.....
cu1sTszTVkP5/rL3CbI+9rgsuCwM67k3DiH4JGOzQpMThPvolCg=

-----END RSA PRIVATE KEY-----

___in id_rsa.pub___
ssh-rsa AAAAB3...SpjX/4t Comment here

After setting up the files, test using your local sftp client:

ssh myuser@mysitewhereIhaveACertificate.com

