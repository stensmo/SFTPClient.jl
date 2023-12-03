# Julia SFTP Client 

*An SFTP Client for Julia.*

A julia package for communicating with SFTP Servers, supporting username and password, or certificate authentication. 

## SFTPClient Features

    - readdir
    - download
    - upload 
    - cd
    - rm 
    - rmdir
    - mkdir
    - mv
    - sftpstat (like stat, but more limited)
## SFTPClient Installation

Install by running:

import Pkg;Pkg.add("SFTPClient")

## SFTPClient Examples

```

    using SFTPClient
    sftp = SFTP("sftp://test.rebex.net/pub/example/", "demo", "password")
    files=readdir(sftp)
    # On Windows, replace this with an appropriate path
    downloadDir="/tmp/"
    SFTPClient.download.(sftp, files, downloadDir=downloadDir)

```

```
    #You can also use it like this
    df=DataFrame(CSV.File(SFTPClient.download(sftp, "/mydir/test.csv")))

    # For certificate authentication, you can do this (since 0.3.8)
    sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser", "cert.pub", "cert.pem")
   
    # The cert.pem is your certificate (private key), and the cert.pub can be obtained from the private # key as following: ssh-keygen -y  -f ./cert.pem. Save the output into "cert.pub". 

```

