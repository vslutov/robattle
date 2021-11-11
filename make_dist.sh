#!/usr/bin/env bash

set -ex

rm -rf robattle robattle.zip
cp -r projects/robattle robattle
sed -e "s/options debugger//g" -i robattle/robattle_main.das
sed -e "s/require daslib\\/debug//g" -i robattle/robattle_main.das

if [[ -f "bin/Release/dasbox.exe" ]]
then
    cp bin/Release/dasbox.exe robattle
else
    cp bin/dasbox.exe robattle
fi

cp README.md robattle

echo "dasbox.exe robattle_main.das" >robattle/start.bat

zip -r -9 robattle.zip robattle
rm -rf robattle
