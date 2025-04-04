using FileWatching
using Downloads
using LibCURL
using URIs
using CSV
using Dates

mutable struct SFTP
    downloader::Downloader
    uri::URI
    username::Union{String, Nothing}
    password::Union{String, Nothing}
    disable_verify_peer::Bool
    disable_verify_host::Bool
    verbose::Bool
    public_key_file::Union{String, Nothing}
    private_key_file::Union{String, Nothing}

end

struct SFTPStatStruct
    desc::String
    mode    :: UInt
    nlink   :: Int
    uid     :: String
    gid     :: String
    size    :: Int64
    mtime   :: Float64
end

function check_and_create_fingerprint(hostNameOrIP::AbstractString)
    dir = homedir()

    try

        known_hosts_file = joinpath(dir, ".ssh", "known_hosts")
     
        rows=CSV.File(known_hosts_file;delim=" ",types=String,header=false)
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
        println("Hostname: $hostNameOrIP")
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
    

    dir = homedir()

    sshdir = joinpath(dir, ".ssh")
    !isdir( sshdir) && mkdir(sshdir)

    known_hosts = joinpath(dir, ".ssh", "known_hosts")
    keyscan = ""
    try 
        keyscan = readchomp(`ssh-keyscan -t ssh-rsa $(hostNameOrIP)`)
    catch e
        println("Keyscan failed. Check if ssh-keyscan is installed")
        if hostNameOrIP == "test.rebex.net"
            # Fix missing keyscan on NanoSoldier
            keyscan = """test.rebex.net ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkRM6RxDdi3uAGogR3nsQMpmt43X4WnwgMzs8VkwUCqikewxqk4U7EyUSOUeT3CoUNOtywrkNbH83e6/yQgzc3M8i/eDzYtXaNGcKyLfy3Ci6XOwiLLOx1z2AGvvTXln1RXtve+Tn1RTr1BhXVh2cUYbiuVtTWqbEgErT20n4GWD4wv7FhkDbLXNi8DX07F9v7+jH67i0kyGm+E3rE+SaCMRo3zXE6VO+ijcm9HdVxfltQwOYLfuPXM2t5aUSfa96KJcA0I4RCMzA/8Dl9hXGfbWdbD2hK1ZQ1pLvvpNPPyKKjPZcMpOznprbg+jIlsZMWIHt7mq2OJXSdruhRrGzZw=="""
        else
            rethrow()
        end
    end

    println("Adding fingerprint $(keyscan) to known_hosts")
    open(known_hosts, "a") do f
        println(f, keyscan)
    end


    return true
end

"""
SFTP(url::AbstractString, username::AbstractString, public_key_file::AbstractString, private_key_file::AbstractString;disable_verify_peer=false, disable_verify_host=false, verbose=false)

 Creates a new SFTP client using certificate authentication, and keys in the files specified

  sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser", "test.pub", "test.pem")
  

"""
function SFTP(url::AbstractString, username::AbstractString, public_key_file::AbstractString, private_key_file::AbstractString;disable_verify_peer=false, disable_verify_host=false, verbose=false)
    downloader = Downloads.Downloader()

    uri = URI(url)


    sftp = SFTP(downloader, uri, username, nothing, disable_verify_peer, disable_verify_host, verbose, public_key_file, private_key_file)
    slashEnd(sftp)
    reset_easy_hook(sftp)
    return sftp
end



"""
 SFTP(url::AbstractString, username::AbstractString;disable_verify_peer=false, disable_verify_host=false)
 
 Creates a new SFTP client using certificate authentication. 

  sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser")
  
  Note! You must provide the username for this to work. 

  Before using this method, you must set up your certificates in ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub

  Of course, the host need to be in the known_hosts file as well. 

  Test using your local client first: ssh myuser@mysitewhereIhaveACertificate.com

  See other method if you want to use files not in ~/ssh/

"""
function SFTP(url::AbstractString, username::AbstractString;disable_verify_peer=false, disable_verify_host=false, verbose=false)
    downloader = Downloads.Downloader()

    uri = URI(url)


    sftp = SFTP(downloader, uri, username, nothing, disable_verify_peer, disable_verify_host, verbose, nothing, nothing)
    slashEnd(sftp)
    reset_easy_hook(sftp)
    return sftp
end

"""
 SFTP(url::AbstractString, username::AbstractString, password::AbstractString;create_known_hosts_entry=true, disable_verify_peer=false, disable_verify_host=false)

Creates a new SFTP Client:
url: The url to connect to, e.g., sftp://mysite.com
username: The username to use
password: The users password
create_known_hosts_entry: Automatically create an entry in known hosts


Example:
sftp = SFTP("sftp://test.rebex.net", "demo", "password")


"""
function SFTP(url::AbstractString, username::AbstractString, password::AbstractString;create_known_hosts_entry=true, disable_verify_peer=false, disable_verify_host=false, verbose=false)
    downloader = Downloads.Downloader()

    uri = URI(url)

    host = uri.host

    create_known_hosts_entry && check_and_create_fingerprint(host)

    sftp = SFTP(downloader, uri, username, password, disable_verify_peer, disable_verify_host, verbose, nothing, nothing)
    slashEnd(sftp)
    reset_easy_hook(sftp)
    return sftp
end

function slashEnd(sftp)
    path = sftp.uri.path
    if !endswith(path, "/") 
        path = path * "/"
    end
    newUrl = resolvereference(sftp.uri, escapepath(path))
        
    sftp.uri = newUrl

end

function setStandardOptions(sftp, easy, info)
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

 
    if sftp.public_key_file != nothing
     Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_SSH_PUBLIC_KEYFILE, sftp.public_key_file)
    end

    if sftp.private_key_file != nothing
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_SSH_PRIVATE_KEYFILE, sftp.private_key_file)
    end

    if sftp.verbose
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_VERBOSE, 1)
    end

end

function reset_easy_hook(sftp::SFTP) 
        
        downloader = sftp.downloader
        

        downloader.easy_hook = (easy, info) -> begin
        setStandardOptions(sftp, easy, info)
        Downloads.Curl.setopt(easy, CURLOPT_DIRLISTONLY, 1)


        
        
    end
end


function sftpescapepath(path::String)
    
    return escapepath(path)
end


#=
    Note, this function should not use URL:s since CURL:s api need spaces
=#
function handleRelativePath(fileName, sftp::SFTP)
    baseUrl = string(sftp.uri)
    #println("base url $baseUrl")
    resolvedReference = resolvereference(baseUrl, fileName)
    fileName = "'" * unescapeuri(resolvedReference.path) * "'"
    println(fileName)
    return fileName
end

function ftp_command(sftp::SFTP, command::String)
    slist = Ptr{Cvoid}(0)
  
    slist = curl_slist_append(slist, command)

    sftp.downloader.easy_hook = (easy, info) -> begin
        setStandardOptions(sftp, easy, info)
  
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

function sftpstat2(sftp, dir::String)
    
    stats = sftpstat(sftp, dir)
    a = filter(x->x.desc != "." && x.desc != "..",stats )
    return a;
end

function myjoinpath(path::AbstractString, name::AbstractString)
    path == "." && return name
    #println("path $path")
    #println("name $name")
    path*"/" * name * "/"

end


"""
    SFTPClient.walkdir(sftp::SFTP, root; topdown=true, follow_symlinks=false, onerror=throw)
    Return an iterator that walks the directory tree of a directory.
    The iterator returns a tuple containing `(rootpath, dirs, files)`.

    
    # Examples
    ```julia
    for (root, dirs, files) in walkdir(sftp, ".")
        println("Directories in \$root")
        for dir in dirs
            println(joinpath(root, dir)) # path to directories
        end
        println("Files in \$root")
        for file in files
            println(joinpath(root, file)) # path to files
        end
    end
    ```

"""
function walkdir(sftp::SFTP, root; topdown=true, follow_symlinks=false, onerror=throw)
    function _walkdir(chnl, root)
   
        tryf2( f, sftp, p) = try
                f(sftp, p)
            catch err
                show(err)
                isa(err, IOError) || rethrow()
                try
                    onerror(err)
                catch err2
                    close(chnl, err2)
                end
                return
            end

            tryf( f, p) = try
                f(p)
            catch err
                show(err)
                isa(err, IOError) || rethrow()
                try
                    onerror(err)
                catch err2
                    
                    close(chnl, err2)
                end
                return
            end

        content = tryf2(sftpstat2, sftp , root)

        content === nothing && return
        dirs = Vector{String}()
        files = Vector{String}()
        for statstruct in content
 
            name = statstruct.desc
           
            path = myjoinpath(root, name)
            
   
            isadir = tryf(isdir, statstruct)
      

            # If we're not following symlinks, then treat all symlinks as files
            if (!follow_symlinks && something(tryf(islink, statstruct), true)) || !something(tryf(isdir, statstruct), false)
                push!(files, name)
            else
                push!(dirs, name)
            end
        end

        if topdown
            push!(chnl, (root, dirs, files))
        end
        for dir in dirs
            _walkdir(chnl, myjoinpath(root, dir))
        end
        if !topdown
            push!(chnl, (root, dirs, files))
        end
        nothing
    end
    return Channel{Tuple{String,Vector{String},Vector{String}}}(chnl -> _walkdir(chnl, root))
end





Base.broadcastable(sftp::SFTP) = Ref(sftp)


"""
    islink(path) -> Bool

Return `true` if `path` is a symbolic link, `false` otherwise.
"""
Base.islink(st::SFTPStatStruct) = filemode(st) & 0xf000 == 0xa000



"""
Base.isdir(st::SFTPStatStruct) 

Test if st is a directory
"""
Base.isdir(st::SFTPStatStruct) = filemode(st) & 0xf000 == 0x4000

"""
Base.isfile(st::SFTPStatStruct) 

Test if st is a file
"""
Base.isfile(st::SFTPStatStruct) = filemode(st) & 0xf000 == 0x8000

"""
Base.isdir(st::SFTPStatStruct) 

Get the filemode of the directory
"""
Base.filemode(st::SFTPStatStruct) = st.mode

function parseDate(monthPart::String, dayPart::String, yearOrTimePart::String)
     yearStr::String = occursin(":",yearOrTimePart) ? string(year(now())) : yearOrTimePart
     timeStr::String = !occursin(":",yearOrTimePart) ? "00:00" : yearOrTimePart

     dateTime = DateTime("$monthPart $dayPart $yearStr $timeStr",dateformat"u d yyyy H:M ")
 
    return datetime2unix(dateTime)
end

function parseMode(s::String)::UInt
    length(s) != 10 && error("Not correct lenght")

    dirChar = s[1]

    dir = (dirChar == 'd') ? 0x4000 : 0x8000

    owner = strToNumber(s[2:4])
    group = strToNumber(s[5:7])
    anyone = strToNumber(s[8:10])

    return dir + owner * 8^2 + group * 8^1 + anyone * 8^0

end

function strToNumber(s::String)::Int64
    b1 = (s[1] != '-') ?  4 : 0
    b2 = (s[2] != '-') ?  2 : 0
    b3 = (s[3] != '-') ?  1 : 0
    return b1+b2+b3
end

function parseStat(s::String)

    resultVec = Vector{String}(undef, 9)

    lastIndex = 1

    parseCounter = 1

    stringLength = length(s)

    i = 1
    
    while (i < stringLength)
        c = s[i]
        if c == ' '
            resultVec[parseCounter] = s[lastIndex:i-1]
            parseCounter += 1
            
            while (i < stringLength && c == ' ')
                i += 1
                c = s[i]
            end

            lastIndex = i

            if parseCounter == 9 
                resultVec[parseCounter] = s[lastIndex:end]
                break
            end

        end

        i += 1
    end
    return resultVec
    
end




function makeStruct(stats::Vector{String})::SFTPStatStruct
    SFTPStatStruct(stats[9], parseMode(stats[1]),  parse(Int64, stats[2]), stats[3], stats[4], parse(Int64, stats[5]), parseDate(stats[6], stats[7], stats[8]))  
end

"""
sftpstat(sftp::SFTP)

Like Julia stat, but returns a Vector of SFTPStatStructs. Note that you can only run this on directories. Can be used for checking if a file was modified, and much more.

"""

sftpstat(sftp::SFTP) = sftpstat(sftp::SFTP, ".")


"""
sftpstat(sftp::SFTP, path::AbstractString)

Like Julia stat, but returns a Vector of SFTPStatStructs. Note that you can only run this on directories. Can be used for checking if a file was modified, and much more.

"""
function sftpstat(sftp::SFTP, path::AbstractString)


    sftp.downloader.easy_hook = (easy, info) -> begin
        setStandardOptions(sftp, easy, info)

    end

    output = nothing

    try

        if !isdirpath(path)
            path = path * "/"
        end

        newUrl = resolvereference(sftp.uri,sftpescapepath(path))


        io = IOBuffer();

        try
            output = Downloads.download(string(newUrl), io; sftp.downloader)
            
            
        finally 
            reset_easy_hook(sftp)
        end


        # Don't know why this is necessary
        res = String(take!(io))
        io2 = IOBuffer(res)

        stats = readlines(io2;keep=false)
        
        return makeStruct.(parseStat.(stats))
        #return files
    catch e
        rethrow()
    end


end




"""
upload(sftp::SFTP, file_name::AbstractString)

Upload (put) a file to the server. Broadcasting can be used too. 

files=readdir()
upload.(sftp,files)

"""
function upload(sftp::SFTP,
    file_name::AbstractString)

       
        open(file_name, "r") do local_file


            file = escapeuri(basename(file_name))

            uri = resolvereference(sftp.uri, file)

            output = Downloads.request(string(uri), input=local_file;downloader=sftp.downloader)
        end

        return nothing
end



"""
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


     
"""
function download(
    sftp::SFTP,
    file_name::AbstractString,
     output = tempname();downloadDir::Union{String, Nothing}=nothing)

    
     if file_name == "." || file_name == ".."
        return
     end

     if downloadDir != nothing
        output = joinpath(abspath(downloadDir), file_name)
     end

     
     uri = resolvereference(sftp.uri, escapeuri(file_name))


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

        #println("URI String $uriString")

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

        newUrl = resolvereference(oldUrl,sftpescapepath(dir))

        #show(newUrl)
       
        sftp.uri = newUrl
        #show(sftp.uri)
        readdir(sftp)
    catch e
        sftp.uri = oldUrl
        rethrow()
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




