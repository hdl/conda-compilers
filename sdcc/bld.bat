ECHO ON

set MSYSTEM=MINGW%ARCH%
set GCC_ARCH=x86_64-w64-mingw32
set CC=%GCC_ARCH%-gcc
set CXX=%GCC_ARCH%-g++
set PATH=%SRC_DIR%\build\bin;%PATH%

python -c "print(r'%PREFIX%'.replace('\\','/'))" > temp.txt
set /p BASH_PREFIX=<temp.txt

md build
cd build
set CPPFLAGS=-I%PREFIX%/Library/include
set CXXFLAGS=-I%PREFIX%/Library/include
bash ../configure --prefix=%BASH_PREFIX% --disable-pic14-port --disable-pic16-port

make -j4
make install
