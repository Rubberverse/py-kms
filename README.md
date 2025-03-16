# 🦆 Rubberverse LAN

Hiya, this is a personalized fork of py-kms for my LAN. It will have some bigger changes eventually compared to this, working on decluttering everything. (Not a python programmer though so that's out of the question)

![repo-size](https://img.shields.io/github/repo-size/Rubberverse/py-kms) ![last-commit](https://img.shields.io/github/last-commit/Rubberverse/py-kms/next)

> [!WARNING]
> Only use this software in a private setting. Never open it up to internet, unless you wanna get striked down by Microsoft. Using this software in official, company setting is a violation of Microsoft license agreement.

## 🍴 Fork changes

Eventually front-end will look better, for now I just did it extra lazy way aka. checking out documentation and changing few variables.

![Dark Theme](https://github.com/user-attachments/assets/5d82c78c-57c8-408a-a0ec-465ec50d1702)

- Default Dark Theme for Overview
- Overview was translated to Polish (it's rough but it's enough to understand)
- Updated `bulma.min.css` to `v1.0.2` + added attribution (MIT license)
- Removed hyperlink to `License` from Overview
- Containers runs as a rootless user by default, UID and GID of `1001:1001`
- Removed `entrypoint.py` #TODO: Replace healtcheck.py and start.py
- Removed `bash` and `shadow` from base image, purge `/var/cache/apk` after apk pulling to free up space on the final image
- Dockerfile updated to use `alpine:edge` and `python 3.12.9-r0`
- Container uses `/app` instead of `/home/py-kms`
- Update package versions in `requirements.txt` #TODO: fix Module tzlocal or pytz not available
- Updated KMSDatabase.xml

## What products can it activate?

⭐ - Fork addition

Activates following versions of **Windows Server**

- [⭐] Windows Server 2025 [Azure Core, Datacenter Azure Edition, Datacenter, Standard)]
- [⭐] Windows Server 2022 [Azure Core, Datacenter Azure Edition, Datacenter, Standard, Datacenter (Semi-Annual Channel), Standard (Semi-Annual Channel)]
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

Activates following Volume Licensing versions of **Windows**

- Windows Vista
- Windows 7
- Windows 8
- Windows 8.1
- Windows 10
- Windows 10 Insider Preview
- Windows 11
- Windows 11 Insider Preview

Activates following Volume Licensing versions of **Office**

- Office 2013
- Office 2013 (Pre-Release)
- Office 2016 (+ Preview)
- Office 2019 (+ Preview [⭐])
- [⭐] Office LTSC 2021 (+ Preview)
- [⭐] Office LTSC 2024 (+ Preview)

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
