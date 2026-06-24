#!/usr/bin/env sh

command_path=${0%/*}
cd "$command_path"
weidu EET/EET.tp2 --log SETUP-EET.DEBUG
exit 0
