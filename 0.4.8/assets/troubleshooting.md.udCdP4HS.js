import{_ as t,c as s,o,al as r}from"./chunks/framework.BAnwHL6M.js";const d=JSON.parse('{"title":"Troubleshooting","description":"","frontmatter":{},"headers":[],"relativePath":"troubleshooting.md","filePath":"troubleshooting.md","lastUpdated":null}'),i={name:"troubleshooting.md"};function n(a,e,h,l,u,p){return o(),s("div",null,e[0]||(e[0]=[r('<h1 id="troubleshooting" tabindex="-1">Troubleshooting <a class="header-anchor" href="#troubleshooting" aria-label="Permalink to &quot;Troubleshooting&quot;">​</a></h1><p>If you get: RequestError: Failure establishing ssh session: -5, Unable to exchange encryption keys while requesting... Try and upgrade to Julia 1.9.4. It seems to be a bug in an underlying library.</p><p>If it does not work, check your known_hosts file in your .ssh directory. ED25519 keys do not seem to work.</p><p>Use the ssh-keyscan tool: From command line, execute: ssh-keyscan [hostname]. Add the ecdsa-sha2-nistp256 line to your known_hosts file. This file is located in your .ssh-directory. This is directory is located in C:\\Users\\your_user.ssh on Windows and ~/.ssh on Linux.</p><p><em><strong>Note: Setting up certificate authentication</strong></em></p><p>To set up certificate authentication, create the certificates in the ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub files. On Windows these are located in C:\\Users\\your_user.ssh.</p><p>Then use the function sftp = SFTP(&quot;sftp://mysitewhereIhaveACertificate.com&quot;, &quot;myuser&quot;) to create a SFTP type.</p><p>Example files</p><p><em><strong>in &quot;known_hosts&quot;</strong></em> mysitewhereIhaveACertificate.com ssh-rsa sdsadxcvacvljsdflsajflasjdfasldjfsdlfjsldfj</p><p><em><strong>in &quot;id_rsa&quot;</strong></em></p><p>––-BEGIN RSA PRIVATE KEY––- ..... cu1sTszTVkP5/rL3CbI+9rgsuCwM67k3DiH4JGOzQpMThPvolCg=</p><p>––-END RSA PRIVATE KEY––-</p><p><em><strong>in id_rsa.pub</strong></em> ssh-rsa AAAAB3...SpjX/4t Comment here</p><p>After setting up the files, test using your local sftp client:</p><p>ssh <a href="mailto:myuser@mysitewhereIhaveACertificate.com" target="_blank" rel="noreferrer">myuser@mysitewhereIhaveACertificate.com</a></p>',15)]))}const m=t(i,[["render",n]]);export{d as __pageData,m as default};
