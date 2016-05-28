#SimpleSambaServer
 
Simple Alpine based samba server.

This is a bare bones samba server which allows for full customisation of the smb.conf file. 
You can define new user accounts and groups, and add users to groups.

The server includes an nmbd service, which is run as a daemon and an smbd service which runs in the forground and can be monitored with `docker logs`

## To run a simple server

  ```
  docker run -d -p 445:445 -p 137:137 -p 139:139 -p 137:137/udp -p 138:138/udp blue/samba \
  -s global:"netbios name = smbhost:workgroup = MYGRP:security = user:map to guest = bad user" \
  -s tmp:"comment = Temporary file space:path = /tmp:read only = no:guest ok = yes" \
  -g 1003:video \
  -g 1004:mp3 \
  -u rita:pass:video:mp3
  ```
  
The ports are required to support the smbd and nmbd services.

The smb.conf file can be configured with the command line options:

```
-s <section_name>:[key=value];... - Define a named section in the smb.conf file with any key/values. This includes setting the global section plus and shares that are required.
-g <group_id>:<group_name>n - Each entry will create a new group in the container. This is useful for mapping group ids of mounted volumes.
-n <user_name>:<password>[:<group_name>:...] - Each entry will create a new user with the username and smb password. The user will also be added to each group name listed.
```

## Volumes

Docker volumes can be mounted with the docker `-v <local>:<container>` option. If the group ids of the shared volumes are not known to the container (most likely) then the group id will need to be set and applied to users with the '-g' and '-n' options.
