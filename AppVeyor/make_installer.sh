#!/usr/bin/env bash
function addFile {
    cp $1 . || (echo cp $1 failed ; return 1)
    7z a -tzip portable.zip $(basename $1) > /dev/null
    echo "Source: \"$(basename $1)\"; DestDir: \"{app}\"; Flags: ignoreversion" >> installer.iss
    echo $1
}

function addFileIn {
    name=$2\\$(basename $1)
    mkdir -p $2
    cp $1 $2 || (echo cp $name failed ; return 1)
    7z a -tzip portable.zip $name > /dev/null
    echo "Source: \"$name\"; DestDir: \"{app}\\$2\"; Flags: ignoreversion" >> installer.iss
    echo $name
}

ver=$(cat src/main.cpp | grep setApplicationVersion | sed "s/\\s*a.setApplicationVersion(\"//g" | sed "s/\");//g")

cd packages/windows
cp ../../KShare.exe . || exit 3
7z a -tzip portable.zip KShare.exe

sed "s/;VER;/$ver/" installer.iss.pattern.top > installer.iss

addFile ../../build/QtAV-depends-windows-x86+x64/bin/avcodec-57.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/avformat-57.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/avutil-55.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/swresample-2.dll
addFile ../../build/QtAV-depends-windows-x86+x64/bin/swscale-4.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Core.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Network.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Gui.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5Widgets.dll
addFile /c/Qt/5.9/mingw53_32/bin/Qt5WinExtras.dll

addFileIn /c/Qt/5.9/mingw53_32/plugins/platforms/qwindows.dll platforms

addFile /c/Qt/5.9/mingw53_32/bin/LIBSTDC++-6.DLL
addFile /c/Qt/5.9/mingw53_32/bin/LIBWINPTHREAD-1.DLL
addFile /c/Qt/5.9/mingw53_32/bin/LIBGCC_S_DW2-1.DLL

addFile /c/OpenSSL-Win32/bin/libeay32.dll
addFile /c/OpenSSL-Win32/bin/ssleay32.dll
addFile /c/OpenSSL-Win32/bin/msvcr120.dll

echo -----------------
ls /c/OpenSSL-Win32/bin/ -R
echo -----------------

cat installer.iss.pattern.bottom >> installer.iss
"C:\Program Files (x86)\Inno Setup 5\ISCC.exe" installer.iss
cp Output/setup.exe ../../installer.exe || exit 1
cp portable.zip ../../ || exit 2
