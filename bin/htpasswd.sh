#!/bin/bash
# Generates htpasswd lines without using htpasswd utility
set -e

echo -n "Username? "
read usr
pw=$(pwgen -1 18)
hsh=$(openssl passwd -apr1 $pw)
printf "$usr:$hsh\n#$usr:$pw\n"
