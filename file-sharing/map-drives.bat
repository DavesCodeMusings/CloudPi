@echo off

REM Change the servername below to match your setup.
set servername=mypi

net use m: \\%servername%\media /persistent:yes
net use p: \\%servername%\public /persistent:yes
net use s: \\%servername%\shared /persistent:yes
