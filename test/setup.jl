using SFTPClient
using Test


sftp = SFTP("sftp://test.rebex.net", "demo", "password")
cd(sftp, "/pub/example")


files = readdir(sftp)

tempDir = "/tmp/"


if Sys.iswindows()
    tempDir = ENV["Temp"] * "\\"
end

SFTPClient.download.(sftp, files, downloadDir=tempDir)

cd(sftp, "../")
dirs = readdir(sftp)

cd(sftp, "..")

SFTPClient.download.(sftp, "readme.txt", downloadDir=".")


actualFiles = ["KeyGenerator.png",
"KeyGeneratorSmall.png",
"ResumableTransfer.png",
"WinFormClient.png",
"WinFormClientSmall.png",
"imap-console-client.png",
"mail-editor.png",
"mail-send-winforms.png",
"mime-explorer.png",
"pocketftp.png",
"pocketftpSmall.png",
"pop3-browser.png",
"pop3-console-client.png",
"readme.txt",
"winceclient.png",
"winceclientSmall.png"]