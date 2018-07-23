#!/bin/sh

command_path=${0%/*}
cd "$command_path"
chmod +x EET/bin/osx/x86_64/weidu
./EET/bin/osx/x86_64/weidu EET/EET.tp2 --log SETUP-EET.DEBUG
exit 0
