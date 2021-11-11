set CONFIGURATION=Debug
set VS_NUMBER=2019

call   "%programfiles(x86)%\Microsoft Visual Studio\%VS_NUMBER%\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

pushd cmake_tmp
msbuild dasbox.vcxproj /p:Configuration=%CONFIGURATION%
popd