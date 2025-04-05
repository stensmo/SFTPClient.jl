```@raw html
---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "SFTPClient.jl"
  text: "SFTP in Julia"
  tagline: Julia SFTP client, supporting username and password, or certificate authentication.
  image:
    src: /logo.png
    alt: Julia SFTP Client
  actions:
    - theme: alt
      text: View on Github
      link: https://github.com/stensmo/SFTPClient.jl
    - theme: alt
      text: API
      link: /api


features:
  - icon: <img width="64" height="64" src="https://img.icons8.com/arcade/64/markdown.png" alt="markdown"/>
    title: Complete set of operations
    details: download, upload, remove files, walk directories
    link: /api

  - icon: <img width="64" height="64" src="https://img.icons8.com/arcade/64/markdown.png" alt="markdown"/>
    title: Authentication
    details: Username and password, as well as certificate authentication
    link: /api

---
``` 


## SFTPClient Installation

Install by running:
```julia
import Pkg;Pkg.add("SFTPClient")
```

## SFTPClient Examples

Examples:

```julia
using SFTPClient

# Replace with your actual credentials
  username = "demo"
  password = "password"
  url = "sftp://test.rebex.net/pub/example/"

  file_name = "readme.txt"

  sftp = SFTP(url, username, password)

try
    SFTPClient.download(sftp, file_name;downloadDir=".")
    println("File downloaded successfully! $(file_name)")
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
