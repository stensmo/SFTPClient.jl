import{_ as s,c as n,o as p,aA as e}from"./chunks/framework.CAC67dkV.js";const h=JSON.parse('{"title":"Julia SFTP Client","description":"","frontmatter":{},"headers":[],"relativePath":"index.md","filePath":"index.md","lastUpdated":null}'),t={name:"index.md"};function l(i,a,o,c,r,u){return p(),n("div",null,a[0]||(a[0]=[e(`<h1 id="Julia-SFTP-Client" tabindex="-1">Julia SFTP Client <a class="header-anchor" href="#Julia-SFTP-Client" aria-label="Permalink to &quot;Julia SFTP Client {#Julia-SFTP-Client}&quot;">​</a></h1><p><em>An SFTP Client for Julia.</em></p><p>A julia package for communicating with SFTP Servers, supporting username and password, or certificate authentication.</p><h2 id="SFTPClient-Features" tabindex="-1">SFTPClient Features <a class="header-anchor" href="#SFTPClient-Features" aria-label="Permalink to &quot;SFTPClient Features {#SFTPClient-Features}&quot;">​</a></h2><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>- readdir</span></span>
<span class="line"><span>- download</span></span>
<span class="line"><span>- upload </span></span>
<span class="line"><span>- cd</span></span>
<span class="line"><span>- walkdir</span></span>
<span class="line"><span>- rm </span></span>
<span class="line"><span>- rmdir</span></span>
<span class="line"><span>- mkdir</span></span>
<span class="line"><span>- mv</span></span>
<span class="line"><span>- sftpstat (like stat, but more limited)</span></span></code></pre></div><h2 id="SFTPClient-Installation" tabindex="-1">SFTPClient Installation <a class="header-anchor" href="#SFTPClient-Installation" aria-label="Permalink to &quot;SFTPClient Installation {#SFTPClient-Installation}&quot;">​</a></h2><p>Install by running:</p><p>import Pkg;Pkg.add(&quot;SFTPClient&quot;)</p><h2 id="SFTPClient-Examples" tabindex="-1">SFTPClient Examples <a class="header-anchor" href="#SFTPClient-Examples" aria-label="Permalink to &quot;SFTPClient Examples {#SFTPClient-Examples}&quot;">​</a></h2><p>Examples:</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>using SFTPClient</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Replace with your actual credentials</span></span>
<span class="line"><span>  username = &quot;demo&quot;</span></span>
<span class="line"><span>  password = &quot;password&quot;</span></span>
<span class="line"><span>  url = &quot;sftp://test.rebex.net/pub/example/&quot;</span></span>
<span class="line"><span></span></span>
<span class="line"><span>  file_name = &quot;readme.txt&quot;</span></span>
<span class="line"><span></span></span>
<span class="line"><span>  sftp = SFTP(url, username, password)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>try</span></span>
<span class="line"><span>    SFTPClient.download(sftp, file_name;downloadDir=&quot;.&quot;)</span></span>
<span class="line"><span>    println(&quot;File downloaded successfully! $(file_name)&quot;)</span></span>
<span class="line"><span>catch e</span></span>
<span class="line"><span>    println(&quot;Error downloading file: &quot;, e)</span></span>
<span class="line"><span>end</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span></span></span>
<span class="line"><span>    using SFTPClient</span></span>
<span class="line"><span>    sftp = SFTP(&quot;sftp://test.rebex.net/pub/example/&quot;, &quot;demo&quot;, &quot;password&quot;)</span></span>
<span class="line"><span>    files=readdir(sftp)</span></span>
<span class="line"><span>    # On Windows, replace this with an appropriate path</span></span>
<span class="line"><span>    downloadDir=&quot;/tmp/&quot;</span></span>
<span class="line"><span>    SFTPClient.download.(sftp, files, downloadDir=downloadDir)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>    statStructs = sftpstat(sftp)</span></span></code></pre></div><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>    #You can also use it like this</span></span>
<span class="line"><span>    df=DataFrame(CSV.File(SFTPClient.download(sftp, &quot;/mydir/test.csv&quot;)))</span></span>
<span class="line"><span>    # For certificates you can use this for setting it up</span></span>
<span class="line"><span>    sftp = SFTP(&quot;sftp://mysitewhereIhaveACertificate.com&quot;, &quot;myuser&quot;)</span></span>
<span class="line"><span>    # Since 0.3.8 you can also do this</span></span>
<span class="line"><span>    sftp = SFTP(&quot;sftp://mysitewhereIhaveACertificate.com&quot;, &quot;myuser&quot;, &quot;cert.pub&quot;, &quot;cert.pem&quot;) # Assumes cert.pub and cert.pem is in your current path</span></span>
<span class="line"><span>    # The cert.pem is your certificate (private key), and the cert.pub can be obtained from the private key.</span></span>
<span class="line"><span>    # ssh-keygen -y  -f ./cert.pem. Save the output into &quot;cert.pub&quot;.</span></span></code></pre></div><p>Full example for working with JSON</p><div class="language- vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang"></span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span>using SFTPClient</span></span>
<span class="line"><span>using DataFrames</span></span>
<span class="line"><span>using JSON</span></span>
<span class="line"><span></span></span>
<span class="line"><span># Replace with your actual credentials</span></span>
<span class="line"><span>  username = &quot;username&quot;</span></span>
<span class="line"><span>  password = &quot;password&quot;</span></span>
<span class="line"><span>  url = &quot;sftp://myserver/directory/&quot;</span></span>
<span class="line"><span></span></span>
<span class="line"><span>  file_name = &quot;wheat.json&quot;</span></span>
<span class="line"><span></span></span>
<span class="line"><span>  sftp = SFTP(url, username, password)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>  try</span></span>
<span class="line"><span>        SFTPClient.download(sftp, file_name;downloadDir=&quot;.&quot;)</span></span>
<span class="line"><span>        println(&quot;File downloaded successfully!&quot;)</span></span>
<span class="line"><span>  catch e</span></span>
<span class="line"><span>        println(&quot;Error downloading file: &quot;, e)</span></span>
<span class="line"><span>  end</span></span>
<span class="line"><span></span></span>
<span class="line"><span>  data = JSON.parsefile(file_name;  null=missing, inttype=Float64)</span></span>
<span class="line"><span></span></span>
<span class="line"><span>  # Convert JSON to DataFrame. The Tables.dictrowtable is necessary for any data which does not have fields for all data. </span></span>
<span class="line"><span>  wheatDF = DataFrame(Tables.dictrowtable(data))</span></span></code></pre></div>`,15)]))}const m=s(t,[["render",l]]);export{h as __pageData,m as default};
