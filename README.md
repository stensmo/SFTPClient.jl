# Julia SFTP Client 
Package for working with SFTP in Julia. Built on Downloads.jl, but in my opinion much easier to use. Downloads.jl is in turn based on Curl. 

The Julia SFTP client supports username/password as well as certificates for authentication. 

The following methods are supported: readdir, download, upload, cd, rm, rmdir, mkdir, mv, sftpstat (like stat)
 

Examples:

```julia
using SFTPClient

# Replace with your actual credentials
  username = "demo"
  password = "password"
  server = "sftp://test.rebex.net"
  directory = "/pub/example/"

  filename = "readme.txt"

  sftp = SFTP(server*directory, username, password)

try
    SFTPClient.download(sftp, filename;downloadDir=".")
    println("File downloaded successfully!")
catch e
    println("Error downloading file: ", e)
end

```
Another example for downloading multiple files

```julia

    using SFTPClient
    sftp = SFTP("sftp://test.rebex.net/pub/example/", "demo", "password")
    files=readdir(sftp)
    # On Windows, replace this with an appropriate path
    downloadDir="/tmp/"
    SFTPClient.download.(sftp, files, downloadDir=downloadDir)

    statStructs = sftpstat(sftp)

```
   
Directly download CSV files and load into a dataframe, or use certificates
    
```julia
    #You can also use it like this
    df=DataFrame(CSV.File(SFTPClient.download(sftp, "/mydir/test.csv")))
    # For certificates you can use this for setting it up
    sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser")
    # Since 0.3.8 you can also do this
    sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser", "cert.pub", "cert.pem") # Assumes cert.pub and cert.pem is in your current path
    # The cert.pem is your certificate (private key), and the cert.pub can be obtained from the private key.
    # ssh-keygen -y  -f ./cert.pem. Save the output into "cert.pub". 

```

Full example for working with JSON

```julia
using SFTPClient
using DataFrames
using JSON

# Replace with your actual credentials
  username = "username"
  password = "password"
  url = "sftp://myserver/directory/"

  file_name = "wheat.json"

  sftp = SFTP(url, username, password)

  try
        SFTPClient.download(sftp, file_name;downloadDir=".")
        println("File downloaded successfully!")
  catch e
        println("Error downloading file: ", e)
  end

  data = JSON.parsefile(file_name;  null=missing, inttype=Float64)

  # Convert JSON to DataFrame. The Tables.dictrowtable is necessary for any data which does not have fields for all data. 
  wheatDF = DataFrame(Tables.dictrowtable(data))



```



[API Documentation](https://stensmo.github.io/SFTPClient.jl/stable/api)




