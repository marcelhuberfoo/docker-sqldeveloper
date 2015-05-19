# sqldeveloper
This is an image for running [Oracle SQL Developer][sqldeveloper] without having to install it onto your box.


## Purpose
This docker image builds on top of Arch Linux's marcelhuberfoo/arch image for the
purpose of running [SQL Developer][sqldeveloper] to query or manage your Oracle or
even other databases.

* A non-root user (`user`) is used to execute `oracle-sqldeveloper`. This is important
  for security reasons.
* Access to the data location will be in the volume located at `/data`.  This
  directory will be the default working directory and should have user/group write permissions to work.
* No ssh access required to provide X access.

## Usage
The following command shows a simple scenario in which we link to a running oracle-xe for query:

```bash
docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
      --rm -v /tmp/mydata:/data --link oracle-xe:oracle-xe \
      marcelhuberfoo/sqldeveloper
```

This will execute the default command (`oracle-sqldeveloper`) as `user`.

**Note:** It might be necessary to execute `xhost +` prior to running the container.
Otherwise the display might not be accessible from within the container.


## Permissions
This image uses `user` to run [SQL Developer][sqldeveloper]. This means that your file permissions must allow this user to write to the mapped directory. This user has a `UID` of `1000` and a `GID` of `100` which is equal to the initial `user` and `users` group on most Linux systems. You have to ensure that such a `UID:GID` combination is allowed to write to your mapped volume. The easiest way is to add group write permissions for the mapped volume and change the group id of the volume to 100.

```bash
# To give permissions to the entire project directory, do:
chmod -R g+w /tmp/my-data
chgrp -R 100 /tmp/my-data
```

**Note:** Incorrect permissions might be indicated by a shortly appearing splash screen followed by container termination.


[sqldeveloper]: http://www.oracle.com/technetwork/developer-tools/sql-developer/overview/index.html
