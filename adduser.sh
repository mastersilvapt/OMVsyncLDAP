#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: ./adduser.sh username"
  exit 1;
fi


name="$1"
#password="$3"
shell=/usr/bin/false
groups="users"

useradd "$name" --shell "$shell" --create-home --no-user-group --home-dir "/srv/dev-disk-by-uuid-61ddce35-ae98-4484-9255-a67550867238/homes/$name" || exit 1;#--password "$(mkpasswd $password)"

for i in $groups; do
  usermod -aG "$i" "$name";
done

data="$(cat ./user.template | sed 's/USER/'$name'/')"
#data="$(cat ./user.template | sed 's/EMAIL/'$email'/' | sed 's/USER/'$name'/')"
omv-confdbadm update conf.system.usermngmnt.user "$data" || exit 1
echo "User $name created with success"
