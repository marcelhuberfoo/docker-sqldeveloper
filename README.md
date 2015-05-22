# sqldeveloper [![](https://badge.imagelayers.io/marcelhuberfoo/sqldeveloper.svg)](https://imagelayers.io/?images=marcelhuberfoo/sqldeveloper 'Get your own badge on imagelayers.io')

This is an image for running [Oracle SQL Developer][sqldeveloper] without having to install it onto your box.

## Purpose

This docker image builds on top of my minimal Arch Linux [marcelhuberfoo/arch][dockerarch] image for the
purpose of running [SQL Developer][sqldeveloper] to query or manage your Oracle or
even other databases.

* A non-root user and group `docky` for executing `oracle-sqldeveloper` inside the container.
* A umask of 0002 for user `docky`.
* Exported variables `UNAME`, `GNAME`, `UID` and `GID` to make use of the user settings from within scripts.
* Timezone (`/etc/localtime`) is linked to `Europe/Zurich`, adjust if required in a derived image.
* An external build source folder can be mapped to the volume `/data`. This volume will be the default working directory.
* No ssh access required to provide X access.

## Usage

The following command shows a simple scenario in which we link to a running oracle-xe server for query:

```bash
docker run --rm \
      -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
      -v /tmp/mydata:/data \
      --link oracle-xe:oracle-xe \
      marcelhuberfoo/sqldeveloper
```
This will execute the default command `oracle-sqldeveloper` as `docky`. The `/data` volume can be used to exchange SQL command files with the host. 

**Note:** It might be necessary to execute `xhost +` prior to running the container.
Otherwise the display might not be accessible from within the container.

## Permissions

This image provides a user and group `docky` to run [SQL Developer][sqldeveloper] as user `docky`.

If you map in the `/data` volume, permissions on the host folder must allow user or group `docky` to write to it. I recommend adding at least a group `docky` with GID of `654321` to your host system and change the group of the folder to `docky`. Don't forget to add yourself to the `docky` group.
The user `docky` has a `UID` of `654321` and a `GID` of `654321` which should not interfere with existing ids on regular Linux systems.

Add user and group docky, group might be sufficient:
```bash
groupadd -g 654321 docky
useradd --system --uid 654321 --gid docky --shell '/sbin/nologin' docky
```

Add yourself to the docky group:
```bash
gpasswd --add myself docky
```

Set group permissions to the entire project directory:
```bash
chmod -R g+w /tmp/my-data
chgrp -R docky /tmp/my-data
```

**Note:** Incorrect host folder permissions might be indicated by a shortly appearing splash screen followed by container termination.

[sqldeveloper]: http://www.oracle.com/technetwork/developer-tools/sql-developer/overview/index.html
[dockerarch]: https://registry.hub.docker.com/u/marcelhuberfoo/arch/
