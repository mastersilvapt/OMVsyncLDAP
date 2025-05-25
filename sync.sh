#!/bin/bash

if [[ "$#" -ne 1 ]]; then
        echo "Usage: ./sync.sh"
fi


ldapResp=$(ldapsearch -H ldap://10.204.0.3/ -x -D "cn=Manager,dc=ads,dc=dcc" -b "dc=ads,dc=dcc" -w $(cat ldap.secret) | grep uid: | cut -d: -f2 | sed 's/^\ //');

ldapUSERS=$(echo "$ldapResp" | awk 'BEGIN { printf "[" } { printf "%s\"%s\"", (NR > 1 ? ", " : ""), $1 } END { print "]" }')

omvUSERS=$(omv-confdbadm read conf.system.usermngmnt.user | jq 'map( .name )')

# python3 LDAP OMV -> ADD
# python3 OMV LDAP -> REMOVE

addList=$(python3 ./intersect.py "$ldapUSERS" "$omvUSERS")
echo "AddList $addList"

removeList=$(python3 ./intersect.py "$omvUSERS" "$ldapUSERS")
echo "RemoveList $removeList"

for i in $addList; do
        ./adduser.sh "$i";
done

for i in $removeList; do
        ./deluser.sh "$i";
done
