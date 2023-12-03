using SFTPClient
using Test


sftp = SFTP("sftp://test.rebex.net", "demo", "password")
cd(sftp, "/pub/example")

stats = sftpstat(sftp)

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


actualStructs = [

 SFTPStatStruct(".", 0x00000000000041c0, 2, "demo", "users", 0, 1.6802208e9)
 SFTPStatStruct("..", 0x00000000000041c0, 2, "demo", "users", 0, 1.6802208e9)
 SFTPStatStruct("imap-console-client.png", 0x0000000000008100, 1, "demo", "users", 19156, 1.171584e9)
 SFTPStatStruct("KeyGenerator.png", 0x0000000000008180, 1, "demo", "users", 36672, 1.1742624e9)
 SFTPStatStruct("KeyGeneratorSmall.png", 0x0000000000008180, 1, "demo", "users", 24029, 1.1742624e9)
 SFTPStatStruct("mail-editor.png", 0x0000000000008100, 1, "demo", "users", 16471, 1.171584e9)
 SFTPStatStruct("mail-send-winforms.png", 0x0000000000008100, 1, "demo", "users", 35414, 1.171584e9)
 SFTPStatStruct("mime-explorer.png", 0x0000000000008100, 1, "demo", "users", 49011, 1.171584e9)
 SFTPStatStruct("pocketftp.png", 0x0000000000008180, 1, "demo", "users", 58024, 1.1742624e9)
 SFTPStatStruct("pocketftpSmall.png", 0x0000000000008180, 1, "demo", "users", 20197, 1.1742624e9)
 SFTPStatStruct("pop3-browser.png", 0x0000000000008100, 1, "demo", "users", 20472, 1.171584e9)
 SFTPStatStruct("pop3-console-client.png", 0x0000000000008100, 1, "demo", "users", 11205, 1.171584e9)
 SFTPStatStruct("readme.txt", 0x0000000000008180, 1, "demo", "users", 379, 1.69512912e9)
 SFTPStatStruct("ResumableTransfer.png", 0x0000000000008180, 1, "demo", "users", 11546, 1.1742624e9)
 SFTPStatStruct("winceclient.png", 0x0000000000008180, 1, "demo", "users", 2635, 1.1742624e9)
 SFTPStatStruct("winceclientSmall.png", 0x0000000000008180, 1, "demo", "users", 6146, 1.1742624e9)
 SFTPStatStruct("WinFormClient.png", 0x0000000000008180, 1, "demo", "users", 80000, 1.1742624e9)
 SFTPStatStruct("WinFormClientSmall.png", 0x0000000000008180, 1, "demo", "users", 17911, 1.1742624e9)]