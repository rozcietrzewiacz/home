#!/bin/bash

[[ $# = 0 ]] && exit 1

url=$1

token="$( sqlite3 ~/.config/chromium/Default/Cookies 'SELECT value FROM cookies WHERE host_key="trello.com" AND name="token";' )"

[ "x$token" = "x" ] && exit 2

curl -b "token=$token" $url | json
