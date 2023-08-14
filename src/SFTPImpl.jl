using FileWatching
using Downloads
using LibCURL
using URIs

mutable struct SFTPClient
    downloader::Downloader
    uri::URI
    username::Union{String, Nothing}
    password::Union{String, Nothing}
    disable_verify_peer::Bool
    disable_verify_host::Bool
   
end

"""
 SFTPClient(url::AbstractString;disable_verify_peer=false, disable_verify_host=false)
 
 Creates a new SFTP client using certificate authentication. Provide the username in the url

  sftp = SFTPClient("sftp://nisse@mysitewhereIhaveACertificate.com")
  
  Note! Before your first connect you need to connect to the site using your local sftp install, and make sure the certificate works. On Windows, use Windows PowerShell or command prompt.
  sftp nisse@mysitewhereIhaveACertificate.com

"""
function SFTPClient(url::AbstractString;disable_verify_peer=false, disable_verify_host=false)
    downloader = Downloads.Downloader()

    sftp = SFTPClient(downloader, URI(url), nothing, nothing, disable_verify_peer, disable_verify_host)
    reset_easy_hook(sftp)
    return sftp
end

"""
SFTPClient(url::AbstractString, username::AbstractString, password::AbstractString;disable_verify_peer=false, disable_verify_host=false)

Creates a new SFTPClient:
Example:
sftp = SFTPClient("sftp://test.rebex.net", "demo", "password")
Note! Before your first connect you need to go to the site using your local sftp install, and accept the certificate. On Windows, use Windows PowerShell or command prompt.
sftp demo@test.rebex.net
Accept the certificate, Provide password as the password. 
"""
function SFTPClient(url::AbstractString, username::AbstractString, password::AbstractString;disable_verify_peer=false, disable_verify_host=false)
    downloader = Downloads.Downloader()

    sftp = SFTPClient(downloader, URI(url), username, password, disable_verify_peer, disable_verify_host)
    reset_easy_hook(sftp)
    return sftp
end

function reset_easy_hook(sftp::SFTPClient) 
        
        downloader = sftp.downloader
    

        downloader.easy_hook = (easy, info) -> begin
        if sftp.username != nothing
            Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_USERNAME, sftp.username)
        end
        if sftp.password != nothing
            Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_PASSWORD, sftp.password)
        end

        if sftp.disable_verify_host
        
            Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_SSL_VERIFYHOST , 0)
        end

        if sftp.disable_verify_peer
        
            Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_SSL_VERIFYPEER , 1)
        end


        Downloads.Curl.setopt(easy, CURLOPT_DIRLISTONLY, 1)
      
        
    end
end


function handleRelativePath(fileName, sftp::SFTPClient)
    baseUrl = sftp.uri
    resolvedReference = resolvereference(baseUrl, fileName)
    fileName = resolvedReference.path
    return fileName
end

function ftp_command(sftp::SFTPClient, command::String)
    slist = Ptr{Cvoid}(0)
  
    slist = curl_slist_append(slist, command)

    sftp.downloader.easy_hook = (easy, info) -> begin
    if sftp.username != nothing
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_USERNAME, sftp.username)
    end
    if sftp.password != nothing
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_PASSWORD, sftp.password)
    end

    if sftp.disable_verify_host
    
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_SSL_VERIFYHOST , 0)
    end

    if sftp.disable_verify_peer
    
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_SSL_VERIFYPEER , 1)
    end


  
        Downloads.Curl.setopt(easy,  CURLOPT_QUOTE, slist)
    end

    uri = string(sftp.uri)
    io = IOBuffer()
    output = nothing

    try
        output = Downloads.download(uri, io; sftp.downloader)
        
    finally 
        curl_slist_free_all(slist)
        reset_easy_hook(sftp)
    end

    return output

end


Base.broadcastable(sftp::SFTPClient) = Ref(sftp)


"""
upload(sftp::SFTPClient, file_name::AbstractString)

Upload (put) a file to the server. Broadcasting can be used too. 

files=readdir()
upload.(sftp,files)

"""
function upload(sftp::SFTPClient,
    file_name::AbstractString)

       
        open(file_name, "r") do local_file


            file = basename(file_name)

            uri = resolvereference(sftp.uri, file)

            output = Downloads.request(string(uri), input=local_file;downloader=sftp.downloader)
        end

        return nothing
end



"""
SFTP.download(
    sftp::SFTPClient,
    file_name::AbstractString,
     output = tempname();downloadDir::Union{String, Nothing}=nothing)

     Download a file. You can download it and use it directly, or save it to a file. Specify downloadDir if you want to download files. You can also use broadcasting.
    Example:

    sftp = SFTPClient("sftp://test.rebex.net/pub/example/", "demo", "password")
    files=readdir(sftp)
    downloadDir="/tmp"
    SFTP.download.(sftp, files, downloadDir=downloadDir)

    You can also use it like this:
    df=DataFrame(CSV.File(SFTP.download(sftp, "/mydir/test.csv")))


     
"""
function download(
    sftp::SFTPClient,
    file_name::AbstractString,
     output = tempname();downloadDir::Union{String, Nothing}=nothing)

    
     if file_name == "." || file_name == ".."
        return
     end

     if downloadDir != nothing
        output = downloadDir * file_name
     end

     
     uri = resolvereference(sftp.uri, file_name)

    try
   
        output = Downloads.download(string(uri), output; sftp.downloader)

    catch e
   
        rethrow()
    end
    return output
end

"""
readdir(sftp::SFTPClient, join::Bool = false, sort::Bool = true)

Reads the current directory. Returns a vector of Strings just like the regular readdir function.

"""
function Base.readdir(sftp::SFTPClient, join::Bool = false, sort::Bool = true)
    output = nothing

    try
        uriString = string(sftp.uri)
        if !endswith(uriString, "/")
            uriString = uriString * "/"
            sftp.uri = URI(uriString)
        end

        dir = sftp.uri.path
    

        io = IOBuffer();

        output = Downloads.download(uriString, io; sftp.downloader)


        # Don't know why this is necessary
        res = String(take!(io))
        io2 = IOBuffer(res)
        files = readlines(io2;keep=false)

        files = filter(x->x != "..", files)
        
        files = filter(x->x != ".", files)


        sort && sort!(files)

        join && return joinpath.(dir, files)

        return files
    catch e
        rethrow()
    end

end

"""
    cd(sftp::SFTPClient, dir::AbstractString)
    
    Change the directory for the SFTP client. 

"""
function Base.cd(sftp::SFTPClient, dir::AbstractString)
    
    oldUrl = sftp.uri

    # If we fail, set back to the old url
    try
        newUrl = resolvereference(oldUrl, dir)

        show(newUrl)
       
        sftp.uri = newUrl
        readdir(sftp)
    catch e
        sftp.uri = oldUrl
    end
    return nothing
end


"""
    rm(sftp::SFTPClient, file_name::AbstractString)

    Remove (delete) the file

"""
function Base.rm(sftp::SFTPClient, file_name::AbstractString)
    resp = ftp_command(sftp, "rm $(handleRelativePath(file_name, sftp))")
    return nothing
end

"""
    rmdir(sftp::SFTPClient, dir_name::AbstractString)

    Remove (delete) the directory
"""
function rmdir(sftp::SFTPClient, dir_name::AbstractString)
    resp = ftp_command(sftp, "rmdir $(handleRelativePath(dir_name, sftp))")
    return nothing
end

"""
    mkdir(sftp::SFTPClient, dir::AbstractString)

    Create a directory


"""
function Base.mkdir(sftp::SFTPClient, dir::AbstractString)
    resp = ftp_command(sftp, "mkdir $(handleRelativePath(dir, sftp))")
    return nothing
end

"""
mv(
    sftp::SFTPClient,
    old_name::AbstractString,
    new_name::AbstractString;
)

Move, i.e., rename the file. 

"""
function Base.mv(
    sftp::SFTPClient,
    old_name::AbstractString,
    new_name::AbstractString;
)
    resp = ftp_command(sftp, "rename $(handleRelativePath(old_name, sftp)) $(handleRelativePath(new_name, sftp))")
    return nothing

end





