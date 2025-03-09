# Readme

![repo-size](https://img.shields.io/github/repo-size/Rubberverse/py-kms)
![last-commit](https://img.shields.io/github/last-commit/Rubberverse/py-kms/next)

***

This is a personal fork for my own use case (LAN) so stuff may be changed to my own liking, or fixed up if I can figure out something.

You're not supposed to use this software in an official, company setting as that would be violation of Microsoft license agreement. However, feel free to use this if you need something for personal use, maybe in your home, maybe for your friends.

## Fork changes

![Dark Theme](https://github.com/user-attachments/assets/5d82c78c-57c8-408a-a0ec-465ec50d1702)
![Dark Theme 2](https://github.com/user-attachments/assets/0daa72bb-bb74-4370-a188-5c6c1762abd3)

- Templates lightly translated to Polish and default theme changed to Dark theme
- Updated `bulma.min.css` to v1.0.2
- Remove hyperlink to `License` from main page
- Runs as rootless user by default with UID and GID of `1001`
- Removed `entrypoint.py`
- Dockerfile updated to use `alpine:edge` and `python 3.12`, removed `bash` and `shadow` from base image, purge `/var/cache/apt` to free up space after updates and installation.
- Update package versions in `requirements.txt`
- Use `/app` instead of `/home/py-kms`
- Activates following versions of Windows Server:
	- [Fork] Windows Server 2025 [Azure Core, Datacenter Azure Edition, Datacenter, Standard)]
	- [Fork] Windows Server 2022 [Azure Core, Datacenter Azure Edition, Datacenter, Standard, Datacenter (Semi-Annual Channel), Standard (Semi-Annual Channel)]
	- Windows Server 2019 [Azure Core, Essentials, Datacenter, Standard, ARM64, Datacenter (Semi-Annual Channel), Standard (Semi-Annual Channel)]
	- Windows Server 2016 [Azure Core, Essentials, Datacenter, Standard, ARM64, Datacenter (Semi-Annual Channel), Standard (Semi-Annual Channel), Cloud Storage]
	- Windows Server 2012 R2 [Essentials, Datacenter, Standard, Cloud Storage]
	- Windows Server 2012 [Essentials, Datacenter, Standard, MultiPoint Premium, MultiPoint Standard]
	- Windows Server 2008 R2 A [MultiPoint Server 2010, Web, HPC Edition]
	- Windows Server 2008 R2 B [Standard, Enterprise]
	- Windows Server 2008 R2 C [Datacenter, Enterprise for Itanium]
	- Windows Server 2008 A [Web, Computer Cluster]
	- Windows Server 2008 B [Standard, Standard without Hyper-V, Enterprise, Enterprise without Hyper-V]
	- Windows Server 2008 C [Datacenter, Datacenter without Hyper-V, Enterprise for Itanium]
	- Windows Server Next [Preview Datacenter, Preview Standard, Preview Web, Preview ServerHI]
	- Windows 10 ServerRdsh VL [Enterprise multi-session]
- Activates following Volume Licensing versions of Windows:
	- Windows Vista
	- Windows 7
	- Windows 8
	- Windows 8.1
	- Windows 10
	- Windows 10 Insider Preview
	- Windows 11
	- Windows 11 Insider Preview
- Activates following Volume Licensing versions of Office:
	- Office 2013
	- Office 2013 (Pre-Release)
	- Office 2016 (+ Preview)
	- Office 2019 (+ Preview)
	- [Fork] Office LTSC 2021 (+ Preview)
	- [Fork] Office LTSC 2024 (+ Preview)

## Network Ports

> [!IMPORTANT]
> Use `IP` environmental variable to enable IPv6 support if you require it. To do so, you set the environmental variable to following value `IP=::`. Otherwise, it will listen only on IPv4.

Following ports are used inside of the container:

- 1688/tcp for KMS server
- 8080/tcp for Web Server (Overview)

If you need different web ports, use `--publish` in podman run command, `PublishPort=` in Quadlet, or `Ports:` in Docker Compose. Relevant docs for Podman: [podman run](https://docs.podman.io/en/latest/markdown/podman-run.1.html#publish-p-ip-hostport-containerport-protocol), [systemd-unit](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#container-units-container), [Docker Compose](https://docs.docker.com/get-started/docker-concepts/running-containers/publishing-ports/#use-docker-compose)

```bash
podman run -d localhost/py-kms:latest -p 127.0.0.1:9012:8080/tcp
```

Quadlet configurations can be seen on my personal GitHub repository [here](https://github.com/MrRubberDucky/rubberverse.xyz/blob/main/LOCAL/Utilities/PYKMS.container)

## Volumes

You should mount the database file for data persistence. It's read by the Web Server component. **Make sure that directory permissions match!**

The directory you need to mount is `/app/db` and you can do so in following manner. You will need to create a directory inside of your users' home folder called `AppData/2_PERSIST/PYKMS` that is owned by following UID and GID: `1001:1001`

```bash
mkdir -p ~/AppData/2_PERSIST/PYKMS
```

### Quadlet

> [!WARNING]
> Quadlet functionality is only available since Podman version 5.2+. This feature is not present on Docker.

In case you want to let the container process fix up the permissions by itself, you can pass `U` flag to the `Volume=` argument. This is easiest way to solve permission problems with rootless containers.

```conf
Volume=${HOME}/AppData/2_PERSIST/PYKMS:/app/db:rw,Z,U
```

Here's a full config, based on my home one. Fully ready for production! :) Put it inside `~/.config/systemd/containers/PYKMS.container`, reload systemd - `systemctl --user daemon-reload` and then start it - `systemctl --user start PYKMS`

```cfg
[Unit]
Description=KMS - Key Managment Service, used for Windows & Office activations

[Service]
Restart=on-failure

[Install]
WantedBy=default.target

[Container]
# Base
Image=localhost/py-kms:latest
ContainerName=kms
Volume=${HOME}/AppData/2_PERSIST/PYKMS:/app/db:rw,Z
# Needed for private IPC
Tmpfs=/dev/shm
# Networks
Network=pasta:--ipv4-only
# KMS port
PublishPort=0.0.0.0:1688:1688/tcp
# Dashboard port
PublishPort=127.0.0.1:9012:8080/tcp
```

### Docker-Compose

To bind mount inside the directory, you can do like so:

```yaml
volumes:
    - ${HOME}/AppData/2_PERSIST/PYKMS:/app/db:rw,Z
```

Not providing full compose.yaml as I haven't touched it in well over a year. I'm a heavy Quadlet user right now.

## Building the image locally

Clone this fork, it will be inside of py-kms directory

```bash
git clone https://github.com/Rubberverse/py-kms.git -b next
```

Change your directory

```bash
cd py-kms
```

Move `Dockerfile` from `py-kms/docker/docker-py3-kms/Dockerfile` to root of your current directory

```bash
mv py-kms/docker/docker-py3-kms/Dockerfile .
```

Start build with following command, replace `podman` with `docker` if you're using docker

```bash
podman build -f Dockerfile -t localhost/py-kms:latest
```

If all goes well, it should build successfully. Now you can reference it in your Quadlet or Docker Compose and deploy it! Just use `localhost/py-kms:latest` as your Image registry entry. `Image=localhost/py-kms:latest`


---

# Original fork information

Here you can see the project information.

## History
_py-kms_ is a port of node-kms created by [cyrozap](http://forums.mydigitallife.info/members/183074-markedsword), which is a port of either the C#, C++, or .NET implementations of KMS Emulator. The original version was written by [CODYQX4](http://forums.mydigitallife.info/members/89933-CODYQX4) and is derived from the reverse-engineered code of Microsoft's official KMS.
This version of _py-kms_ is for itself a fork of the original implementation by [SystemRage](https://github.com/SystemRage/py-kms), which was abandoned early 2021.

## Features
- Responds to `v4`, `v5`, and `v6` KMS requests.
- Supports activating:
	- Windows Vista 
	- Windows 7 
	- Windows 8
	- Windows 8.1
	- Windows 10 ( 1511 / 1607 / 1703 / 1709 / 1803 / 1809 )
    - Windows 10 ( 1903 / 1909 / 20H1, 20H2, 21H1, 21H2 )
    - Windows 11 ( 21H2 )
	- Windows Server 2008
	- Windows Server 2008 R2
	- Windows Server 2012
	- Windows Server 2012 R2
	- Windows Server 2016
	- Windows Server 2019
	- Windows Server 2022
	- Microsoft Office 2010 ( Volume License )
	- Microsoft Office 2013 ( Volume License )
	- Microsoft Office 2016 ( Volume License )
	- Microsoft Office 2019 ( Volume License )
	- Microsoft Office 2021 ( Volume License )
  - It's written in Python (tested with Python 3.10.1).
  - Supports execution by `Docker`, `systemd` and many more...
  - Uses `sqlite` for persistent data storage (with a simple web-based explorer).

## Documentation
The wiki has been completly reworked and is now available on [readthedocs.io](https://py-kms.readthedocs.io/en/latest/). It should provide you all the necessary information about how to setup and to use _py-kms_ , all without clumping this readme. The documentation also houses more details about activation with _py-kms_ and how to get GVLK keys.
       
## Quick start
- To start the server, execute `python3 pykms_Server.py [IPADDRESS] [PORT]`, the default _IPADDRESS_ is `::` ( all interfaces ) and the default _PORT_ is `1688`. Note that both the address and port are optional. It's allowed to use IPv4 and IPv6 addresses. If you have a IPv6-capable dual-stack OS, a dual-stack socket is created when using a IPv6 address. **In case your OS does not support IPv6, make sure to explicitly specify the legacy IPv4 of `0.0.0.0`!**
- To start the server automatically using Docker, execute `docker run -d --name py-kms --restart always -p 1688:1688 ghcr.io/py-kms-organization/py-kms`.
- To show the help pages type: `python3 pykms_Server.py -h` and `python3 pykms_Client.py -h`.

## License
   - _py-kms_ is [![Unlicense](https://img.shields.io/badge/license-unlicense-lightgray.svg)](./LICENSE)
