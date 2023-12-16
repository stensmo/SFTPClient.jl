# Troubleshooting

If you get: RequestError: Failure establishing ssh session: -5, Unable to exchange encryption keys while requesting... Try and upgrade to Julia 1.9.4. It seems to be a bug in an underlying library.


If it does not work, check your known_hosts file in your .ssh directory. ED25519 keys do not seem to work.

Use the ssh-keyscan tool: From command line, execute: ssh-keyscan [hostname]. Add the ecdsa-sha2-nistp256 line to your known_hosts file. This file is located in your .ssh-directory. This is directory is located in C:\Users\\{your_user}\\.ssh on Windows and ~/.ssh on Linux.


___Note: Setting up certificate authentication___

To set up certificate authentication, create the certificates in the ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub files. On Windows these are located in C:\Users\\{your user}\\.ssh. 

Then use the function  sftp = SFTP("sftp://mysitewhereIhaveACertificate.com", "myuser") to create a SFTP type.

Example files

___in "known_hosts"___
mysitewhereIhaveACertificate.com ssh-rsa sdsadxcvacvljsdflsajflasjdfasldjfsdlfjsldfj

___in "id_rsa"___

-----BEGIN RSA PRIVATE KEY-----
.....
cu1sTszTVkP5/rL3CbI+9rgsuCwM67k3DiH4JGOzQpMThPvolCg=

-----END RSA PRIVATE KEY-----

___in id_rsa.pub___
ssh-rsa AAAAB3...SpjX/4t Comment here

After setting up the files, test using your local sftp client:

ssh myuser@mysitewhereIhaveACertificate.com






