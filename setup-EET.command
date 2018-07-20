#!/bin/sh

command_path=${0%/*}
cd "$command_path"
chmod +x ./EET/weidu_osx_amd64
./EET/weidu_osx_amd64
exit 0
