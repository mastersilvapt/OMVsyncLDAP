#!/bin/bash


if [[ "$#" -ne 1 ]]; then
        echo "Usage: ./deluser.sh name";
        exit 1;
fi

name="$1"

users=$(omv-confdbadm read conf.system.usermngmnt.user --prettify)
#echo "USERS: $users"

uuid=$(echo "$users" | jq -c '[ .[] | select( .name | contains('\"$name\"'))["uuid"]][0]')

if [[ -z "$uuid" ]]; then
        echo "User not found";
        exit 1;
fi

deluser "$name" || exit 1
rm -rf "/srv/dev-disk-by-uuid-61ddce35-ae98-4484-9255-a67550867238/homes/$name"

uuid_clear=$(echo $uuid | sed 's/\"//g')
#echo "UUID: $uuid_clear"

omv-confdbadm delete conf.system.usermngmnt.user --uuid "$uuid_clear"
echo "User $name removed with success"

