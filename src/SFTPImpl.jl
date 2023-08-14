using FileWatching
using Downloads
using LibCURL
using URIs

mutable struct SFTP
    downloader::Downloader
    uri::URI
    username::Union{String, Nothing}
    password::Union{String, Nothing}
end

function SFTP(url::AbstractString)
    downloader = Downloads.Downloader()

    sftp = SFTP(downloader, URI(url), nothing, nothing)
    reset_easy_hook(sftp)
    return sftp
end

function SFTP(url::AbstractString, username::AbstractString, password::AbstractString)
    downloader = Downloads.Downloader()

    sftp = SFTP(downloader, URI(url), username, password)
    reset_easy_hook(sftp)
    return sftp
end

function reset_easy_hook(sftp::SFTP) 
        
        downloader = sftp.downloader
        username = sftp.username
        password = sftp.password

        downloader.easy_hook = (easy, info) -> begin
        if username != nothing
            Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_USERNAME, username)
        end
        if password != nothing
            Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_PASSWORD, password)
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
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_USERNAME, sftp.username)
        Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_PASSWORD, sftp.password)
        Downloads.Curl.setopt(easy, CURLOPT_DIRLISTONLY, 1)
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



broadcastable(sftp::SFTP) = Ref(sftp)



function download(
    sftp::SFTP,
    file_name::AbstractString,
     output = tempname();downloadDir::Union{String, Nothing}=nothing)

 
     if downloadDir != nothing
        output = downloadDir * file_name
     end

     
     if basename(file_name) == file_name
        file_name = string(sftp.uri) * file_name
     end
    
     #show(file_name)

      #show(output)
    try
   
        output = Downloads.download(file_name, output; sftp.downloader)


        #show(output)
    catch e
   
        rethrow()
    end
    return output
end



function readdir(sftp::SFTP, join::Bool = false, sort::Bool = true)
    output = nothing

    try
        uriString = string(sftp.uri)
        if !endswith(uriString, "/")
            uriString = uriString * "/"
            sftp.uri = URI(uriString)
        end
    

        io = IOBuffer();

        output = Downloads.download(uriString, io; sftp.downloader)

        kaka = readlines(output;keep=false)
        show(kaka)
        res = String(take!(io))
        io2 = IOBuffer(res)

        
        files = readlines(io2;keep=false)
        return files
    catch e
        rethrow()
    end

end



function cd(sftp::SFTP, dir::AbstractString)
    
    oldUrl = sftp.uri
    show(oldUrl)
    # If we fail, set back to the old url
    try
        newUrl = resolvereference(oldUrl, dir)
        show(newUrl)
        sftp.uri = newUrl
        readdir(ftp)
    catch e
        sftp.uri = oldUrl
    end
    return nothing
end




function rm(sftp::SFTP, file_name::AbstractString)
    resp = ftp_command(sftp, "rm $(handleRelativePath(file_name, sftp))")
    return nothing
end


function rmdir(sftp::SFTP, dir_name::AbstractString)
    resp = ftp_command(sftp, "rmdir $(handleRelativePath(dir_name, sftp))")
    return nothing
end


function mkdir(sftp::SFTP, dir::AbstractString)
    resp = ftp_command(sftp, "mkdir $(handleRelativePath(dir, sftp))")
    return nothing
end


function Base.mv(
    sftp::SFTP,
    old_name::AbstractString,
    new_name::AbstractString;
)
    resp = ftp_command(sftp, "rename $(handleRelativePath(old_name, sftp)) $(handleRelativePath(new_name, sftp))")
    return nothing

end





