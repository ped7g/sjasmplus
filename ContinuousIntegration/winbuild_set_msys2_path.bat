rem Borrow bash and other tools from MSYS2 (and put them ahead of other MS crap)
rem set PATH=C:\tools\msys64\usr\bin\;%PATH%;c:\tools\sjasmplus

rem add sjasmplus to path, test availability and version of all required tooling
set PATH=%PATH%;c:\tools\sjasmplus
bash --version
diff --version
cmp --version
where find
find --version
gcc --version
mingw32-make --version
