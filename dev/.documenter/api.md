
# SFTPClient API Documentation {#SFTPClient-API-Documentation}
<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.SFTP-NTuple{4, AbstractString}' href='#SFTPClient.SFTP-NTuple{4, AbstractString}'><span class="jlbinding">SFTPClient.SFTP</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
SFTP(url::AbstractString, username::AbstractString, public_key_file::AbstractString, private_key_file::AbstractString;disable_verify_peer=false, disable_verify_host=false, verbose=false)
```


Creates a new SFTP client using certificate authentication, and keys in the files specified

sftp = SFTP(&quot;sftp://mysitewhereIhaveACertificate.com&quot;, &quot;myuser&quot;, &quot;test.pub&quot;, &quot;test.pem&quot;)


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L105-L113" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.SFTP-Tuple{AbstractString, AbstractString, AbstractString}' href='#SFTPClient.SFTP-Tuple{AbstractString, AbstractString, AbstractString}'><span class="jlbinding">SFTPClient.SFTP</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
SFTP(url::AbstractString, username::AbstractString, password::AbstractString;create_known_hosts_entry=true, disable_verify_peer=false, disable_verify_host=false)
```


Creates a new SFTP Client: url: The url to connect to, e.g., sftp://mysite.com username: The username to use password: The users password create_known_hosts_entry: Automatically create an entry in known hosts

Example: sftp = SFTP(&quot;sftp://test.rebex.net&quot;, &quot;demo&quot;, &quot;password&quot;)


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L158-L172" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.SFTP-Tuple{AbstractString, AbstractString}' href='#SFTPClient.SFTP-Tuple{AbstractString, AbstractString}'><span class="jlbinding">SFTPClient.SFTP</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
SFTP(url::AbstractString, username::AbstractString;disable_verify_peer=false, disable_verify_host=false)
```


Creates a new SFTP client using certificate authentication. 

sftp = SFTP(&quot;sftp://mysitewhereIhaveACertificate.com&quot;, &quot;myuser&quot;)

Note! You must provide the username for this to work. 

Before using this method, you must set up your certificates in ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub

Of course, the host need to be in the known_hosts file as well. 

Test using your local client first: ssh myuser@mysitewhereIhaveACertificate.com

See other method if you want to use files not in ~/ssh/


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L128-L145" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.cd-Tuple{SFTP, AbstractString}' href='#Base.Filesystem.cd-Tuple{SFTP, AbstractString}'><span class="jlbinding">Base.Filesystem.cd</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
cd(sftp::SFTP, dir::AbstractString)

Change the directory for the SFTP client.
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L699-L704" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.filemode-Tuple{SFTPStatStruct}' href='#Base.Filesystem.filemode-Tuple{SFTPStatStruct}'><span class="jlbinding">Base.Filesystem.filemode</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Base.isdir(st::SFTPStatStruct)
```


Get the filemode of the directory


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L427-L431" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.isdir-Tuple{SFTPStatStruct}' href='#Base.Filesystem.isdir-Tuple{SFTPStatStruct}'><span class="jlbinding">Base.Filesystem.isdir</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Base.isdir(st::SFTPStatStruct)
```


Test if st is a directory


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L413-L417" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.isfile-Tuple{SFTPStatStruct}' href='#Base.Filesystem.isfile-Tuple{SFTPStatStruct}'><span class="jlbinding">Base.Filesystem.isfile</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
Base.isfile(st::SFTPStatStruct)
```


Test if st is a file


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L420-L424" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.mkdir-Tuple{SFTP, AbstractString}' href='#Base.Filesystem.mkdir-Tuple{SFTP, AbstractString}'><span class="jlbinding">Base.Filesystem.mkdir</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
mkdir(sftp::SFTP, dir::AbstractString)

Create a directory
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L752-L758" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.mv-Tuple{SFTP, AbstractString, AbstractString}' href='#Base.Filesystem.mv-Tuple{SFTP, AbstractString, AbstractString}'><span class="jlbinding">Base.Filesystem.mv</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
mv(
sftp::SFTP,
old_name::AbstractString,
new_name::AbstractString
)
```


Move, i.e., rename the file. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L765-L774" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.readdir' href='#Base.Filesystem.readdir'><span class="jlbinding">Base.Filesystem.readdir</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)
```


Reads the current directory. Returns a vector of Strings just like the regular readdir function.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L652-L657" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Base.Filesystem.rm-Tuple{SFTP, AbstractString}' href='#Base.Filesystem.rm-Tuple{SFTP, AbstractString}'><span class="jlbinding">Base.Filesystem.rm</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
rm(sftp::SFTP, file_name::AbstractString)

Remove (delete) the file
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L731-L736" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.download' href='#SFTPClient.download'><span class="jlbinding">SFTPClient.download</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
SFTPClient.download(
sftp::SFTP,
file_name::AbstractString,
 output = tempname();downloadDir::Union{String, Nothing}=nothing)

 Download a file. You can download it and use it directly, or save it to a file. 
 Specify downloadDir if you want to save downloaded files. You can also use broadcasting.
Example:

sftp = SFTP("sftp://test.rebex.net/pub/example/", "demo", "password")
files=readdir(sftp)
downloadDir="/tmp"
SFTPClient.download.(sftp, files, downloadDir=downloadDir)

You can also use it like this:
df=DataFrame(CSV.File(SFTPClient.download(sftp, "/mydir/test.csv")))
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L602-L622" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.rmdir-Tuple{SFTP, AbstractString}' href='#SFTPClient.rmdir-Tuple{SFTP, AbstractString}'><span class="jlbinding">SFTPClient.rmdir</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
rmdir(sftp::SFTP, dir_name::AbstractString)

Remove (delete) the directory
```



<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L742-L746" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.sftpstat-Tuple{SFTP, AbstractString}' href='#SFTPClient.sftpstat-Tuple{SFTP, AbstractString}'><span class="jlbinding">SFTPClient.sftpstat</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
sftpstat(sftp::SFTP, path::AbstractString)
```


Like Julia stat, but returns a Vector of SFTPStatStructs. Note that you can only run this on directories. Can be used for checking if a file was modified, and much more.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L520-L525" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.upload-Tuple{SFTP, AbstractString}' href='#SFTPClient.upload-Tuple{SFTP, AbstractString}'><span class="jlbinding">SFTPClient.upload</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



```julia
upload(sftp::SFTP, file_name::AbstractString)
```


Upload (put) a file to the server. Broadcasting can be used too. 

files=readdir() upload.(sftp,files)


<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L574-L582" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='SFTPClient.walkdir-Tuple{SFTP, Any}' href='#SFTPClient.walkdir-Tuple{SFTP, Any}'><span class="jlbinding">SFTPClient.walkdir</span></a> <Badge type="info" class="jlObjectType jlMethod" text="Method" /></summary>



````julia
SFTPClient.walkdir(sftp::SFTP, root; topdown=true, follow_symlinks=false, onerror=throw)
Return an iterator that walks the directory tree of a directory.
The iterator returns a tuple containing `(rootpath, dirs, files)`.


# Examples
```julia
for (root, dirs, files) in walkdir(sftp, ".")
    println("Directories in $root")
    for dir in dirs
        println(joinpath(root, dir)) # path to directories
    end
    println("Files in $root")
    for file in files
        println(joinpath(root, file)) # path to files
    end
end
```
````



<Badge type="info" class="source-link" text="source"><a href="https://github.com/stensmo/SFTPClient.jl/blob/47d8fbb598a31465b89e8a0a073235ce52ac4463/src/SFTPImpl.jl#L309-L329" target="_blank" rel="noreferrer">source</a></Badge>

</details>

