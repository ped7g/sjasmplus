rem Borrow bash and other tools from MSYS2 (and put them ahead of other MS crap)
rem set PATH=C:\tools\msys64\usr\bin\;%PATH%;c:\tools\sjasmplus

rem set bash, find and other tools from git directory to have priority over MS crap and add sjasmplus to path
set PATH=C:\Program Files\Git\usr\bin\;%PATH%;c:\tools\sjasmplus
rem test availability and version of all required tooling
where bash
bash --version
where find
find --version
where diff
diff --version
where cmp
cmp --version
where gcc
gcc --version
where mingw32-make
mingw32-make --version
