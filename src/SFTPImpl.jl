using FileWatching
using Downloads
using LibCURL
using URIs
using CSV

mutable struct SFTP
    downloader::Downloader
    uri::URI
    username::Union{String, Nothing}
    password::Union{String, Nothing}
    disable_verify_peer::Bool
    disable_verify_host::Bool
end

if Sys.iswindows()
    const fileSeparator = "\\"
else
    const fileSeparator = "/"
end


function check_and_create_fingerprint(hostNameOrIP::AbstractString)
    dir = homedir()

    try

        known_hosts_file = joinpath(dir, ".ssh/known_hosts")
        typevec = [String, String, String]

        rows=CSV.File(known_hosts_file;delim=" ",types=typevec,header=false)
        for row in rows
            row[1] != hostNameOrIP && continue
            
            println("Found host in known_hosts")
            # check the entry we found

            fingerprintAlgo = row[2]
            #These are known to work
            (fingerprintAlgo == "ecdsa-sha2-nistp256" || fingerprintAlgo == "ecdsa-sha2-nistp256" || fingerprintAlgo ==  "ecdsa-sha2-nistp521"  || fingerprintAlgo == "ssh-rsa" ) && return
            println("Warning: Correct fingerprint not found in known_hosts")
        end

        println("Creating fingerprint")
        create_fingerprint(hostNameOrIP)

    catch e
        println(e)
        create_fingerprint(hostNameOrIP)

    end

    return nothing

end


function Base.show(io::IO, sftp::SFTP)
 
    join(io, [
        "URL:       $(sftp.uri)",
        "Username:  $(sftp.username)",
    ], "\n")
end

function create_fingerprint(hostNameOrIP::AbstractString)
    
    #run(`mkdir -p ~/.ssh/`)
    #run(`touch ~/.ssh/known_hosts`)
    #run(`ssh-keyscan -t ssh-rsa test.rebex.net >> ~/.ssh/known_hosts`)
    dir = homedir()

    sshdir = joinpath(dir, ".ssh/")
    !isdir( sshdir) && mkdir(sshdir)

    known_hosts = joinpath(dir, ".ssh/known_hosts")
    keyscan = readchomp(`ssh-keyscan -t ssh-rsa $(hostNameOrIP)`)
    println("Adding fingerprint $(keyscan) to known_hosts")
    open(known_hosts, "a") do f
        println(f, keyscan)
    end


    #println(keyscan)

    return true
end


"""
function SFTP(url::AbstractString, username::AbstractString;disable_verify_peer=false, disable_verify_host=false)
 
 Creates a new SFTP client using certificate authentication. Provide the username in the url

  sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser")
  
  Note! You must provide the username for this to work. 

  Before using this method, you must set up your certificates in ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub

  Of course, the server need to be in the known_hosts file as well. 

  Test using your local client first: ssh myuser@mysitewhereIhaveACertificate.com

"""
function SFTP(url::AbstractString, username::AbstractString;disable_verify_peer=false, disable_verify_host=false)
    downloader = Downloads.Downloader()

    uri = URI(url)


    

    sftp = SFTP(downloader, uri, username, nothing, disable_verify_peer, disable_verify_host)
    reset_easy_hook(sftp)
    return sftp
end

"""
function SFTP(url::AbstractString, username::AbstractString, password::AbstractString;create_known_hosts_entry=true, disable_verify_peer=false, disable_verify_host=false)

Creates a new SFTP Client:
url: The url to connect to, e.g., sftp://mysite.com
username: The username to use
password: The users password
create_known_hosts_entry: Automatically create an entry in known hosts


Example:
sftp = SFTP("sftp://test.rebex.net", "demo", "password")


"""
function SFTP(url::AbstractString, username::AbstractString, password::AbstractString;create_known_hosts_entry=true, disable_verify_peer=false, disable_verify_host=false)
    downloader = Downloads.Downloader()

    uri = URI(url)

    host = uri.host

    create_known_hosts_entry && check_and_create_fingerprint(host)

    sftp = SFTP(downloader, uri, username, password, disable_verify_peer, disable_verify_host)
    reset_easy_hook(sftp)
    return sftp
end

function reset_easy_hook(sftp::SFTP) 
        
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


function handleRelativePath(fileName, sftp::SFTP)
    baseUrl = sftp.uri
    resolvedReference = resolvereference(baseUrl, fileName)
    fileName = resolvedReference.path
    return fileName
end

function ftp_command(sftp::SFTP, command::String)
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


Base.broadcastable(sftp::SFTP) = Ref(sftp)


"""
upload(sftp::SFTP, file_name::AbstractString)

Upload (put) a file to the server. Broadcasting can be used too. 

files=readdir()
upload.(sftp,files)

"""
function upload(sftp::SFTP,
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


     
"""
function download(
    sftp::SFTP,
    file_name::AbstractString,
     output = tempname();downloadDir::Union{String, Nothing}=nothing)

    
     if file_name == "." || file_name == ".."
        return
     end

     if downloadDir != nothing
        if !isdirpath(downloadDir)
            downloadDir = downloadDir * fileSeparator
        end

        if downloadDir == "."
            downloadDir = downloadDir * fileSeparator
        end

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
readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)

Reads the current directory. Returns a vector of Strings just like the regular readdir function.

"""
function Base.readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)
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
    cd(sftp::SFTP, dir::AbstractString)
    
    Change the directory for the SFTP client. 

"""
function Base.cd(sftp::SFTP, dir::AbstractString)
    
    oldUrl = sftp.uri

    # If we fail, set back to the old url
    try


        if !isdirpath(dir)
            dir = dir * "/"
        end

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
    rm(sftp::SFTP, file_name::AbstractString)

    Remove (delete) the file

"""
function Base.rm(sftp::SFTP, file_name::AbstractString)
    resp = ftp_command(sftp, "rm $(handleRelativePath(file_name, sftp))")
    return nothing
end

"""
    rmdir(sftp::SFTP, dir_name::AbstractString)

    Remove (delete) the directory
"""
function rmdir(sftp::SFTP, dir_name::AbstractString)
    resp = ftp_command(sftp, "rmdir $(handleRelativePath(dir_name, sftp))")
    return nothing
end

"""
    mkdir(sftp::SFTP, dir::AbstractString)

    Create a directory


"""
function Base.mkdir(sftp::SFTP, dir::AbstractString)
    resp = ftp_command(sftp, "mkdir $(handleRelativePath(dir, sftp))")
    return nothing
end

"""
mv(
    sftp::SFTP,
    old_name::AbstractString,
    new_name::AbstractString;
)

Move, i.e., rename the file. 

"""
function Base.mv(
    sftp::SFTP,
    old_name::AbstractString,
    new_name::AbstractString;
)
    resp = ftp_command(sftp, "rename $(handleRelativePath(old_name, sftp)) $(handleRelativePath(new_name, sftp))")
    return nothing

end




