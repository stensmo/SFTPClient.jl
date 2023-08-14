# SFTP in Julia
Package for working with SFTP in Julia. Built on Downloads.jl, but in my opinion much easier to use. Downloads.jl is in turn based on Curl. 

The SFTP client supports username/password as well as certificates for authentication.

___Note: You must first use your local sftp client to set up certificates___
This is done in Windows by using Command Line (cmd.exe) or Windows PowerShell. in Linux use your favorite shell. 
Execute "sftp myuser@siteIwantToConnectTo.com" and acccept any certificates. After this you should be able to connect via the Julia SFTP Client. 
