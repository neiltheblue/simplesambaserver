SimpleSambaServer
Simple Alpine base samba server.

This is a bare bones samba server which allows for full customisation of the smb.conf file. 
You can define new user accounts and groups, and add users to groups.

## To use run a simple server

docker run -d -p 445:445 -p 137:137 -p 139:139 -p 137:137/udp -p 138:138/udp blue/samba 
-s global:"netbios name = smbhost:workgroup = MYGRP:security = user:map to guest = bad user:printing=bsd:printcap name = /dev/null" -s tmp:"comment = Temporary file space:path = /tmp:read only = no:guest ok = yes"
