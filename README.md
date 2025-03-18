# 🦆 Rubberverse Containers

Hiya, this is a personalized fork of py-kms for my LAN. It will have some bigger changes eventually compared to this, working on decluttering everything. (Not a python programmer though so that's out of the question)

![repo-size](https://img.shields.io/github/repo-size/Rubberverse/py-kms) ![last-commit](https://img.shields.io/github/last-commit/Rubberverse/py-kms/next)

> [!WARNING]
> Only use this software in a private setting. Never open it up to internet, unless you wanna get striked down by Microsoft. Using this software in official, company setting is a violation of Microsoft license agreement.

## 🍴 Fork changes (so far)

![Dark Theme](https://github.com/user-attachments/assets/5d82c78c-57c8-408a-a0ec-465ec50d1702)

Eventually the front-end will be better. I'm just seeing what it would be worthwhile switching to.

**Front-end changes**

- Dark theme for Overview
- Partial Polish translation for Overview (default for now, eventually multi-lang will be a thing... maybe.)
- Updated `bulma.min.css` to `v1.0.2` and added attibution (MIT license)
- Removed hyperlink to `License` from Overview

**Container changes**

- Removed `entrypoint.py`
- Removed `bash` and `shadow`, purge `/var/cahe/apk` after apk installation process to free up space in the final image
- Dockerfile uses `alpine:edge` with latest packages and `python 3.12.9-r0`, tidy up overall structure.
- Change default directory from `/home/py-kms` to `/app`
- Update package pinnings in `requirements.txt`

**pykms changes**

- WebUI: Don't dump logs into the overview in case of failure, instead log them to console with a message to go check it.
- Database: Updated `KMSDatabase.xml` with latest License Manager 5.1 changes, declutterified it to enhance py-kms performance and give it better reliability long-term (v2.0)

## 🔨 Planned changes

ToDo list if you will.

- [ ] Replace `start.py` and `healtcheck.py` with `sh` scripts
- [ ] Simplify environmental variables
- [ ] Better descriptions for database entries
- [ ] Make front-end better

## 🐳 Image tags



## 🤔 What products can it activate?

Activates following versions of **Windows Server**, only **Volume Licensing** SKUs are compatible with this!

^: Semi-Annual channels included for Datacenter and Standard

| Windows Server Version    | Editions                                                                                                                             |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Windows Server 2025^      | Azure Core, Datacenter Azure Edition, Datacenter Standard                                                                            |
| Windows Server 2022^      | Azure Core, Datacenter Azure Edition, Datacenter, Standard                                                                           |
| Windows Server 2016       | Azure Core, Essentials, Datacenter, Standard, ARM64, Cloud Storage                                                                   |
| Windows Server 2012 R2    | Essentials, Datacenter, Standard, Cloud Storage                                                                                      |
| Windows Server 2012       | Essentials, Datacenter, Standard, MultiPoint Premium, MultiPoint Standard                                                            |
| Windows Server 2008 R2 A  | MultiPoint Server 2010, Web, HPC Edition                                                                                             |
| Windows Server 2008 R2 B  | Standard, Enterprise                                                                                                                 |
| Windows Server 2008 R2 C  | Datacenter, Enterprise for Itanium                                                                                                   |
| Windows Server 2008 A     | Web, Computer Cluster                                                                                                                |
| Windows Server 2008 B     | Standard, Enterprise                                                                                                                 |
| Windows Server 2008 C     | Datacenter, Datacenter without Hyper-V, Enterprise for Itanium                                                                       |
| Windows Server Next       | Preview Datacenter, Preview Standard, Preview Web, Preview ServerHI                                                                  |
| Windows 10 ServerRdsh VL  | Enterprise multi-session                                                                                                             |

Activates following Volume Licensing versions of **Windows**, only **Volume Licensing** SKUs are compatible with this!

Enterprise G, Enterprise G N is known as China Government, Enterprise multi-session is known as ServerRdsh VL

| Windows Version             | Editions                                                                                                                                                                             |
|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Windows 11                 | Enterprise, Enterprise N, Enterprise G, Enterprise G N, Enterprise Multi-session, Education, Education N, Pro, Pro N, Pro Education, Pro Education N, Pro Workstation, Pro Workstation N, IoT Enterprise LTSC 2021-2024, S (Lean), Remote Server  |
| Windows 11 Insider Preview | Enterprise, Enterprise N, Enterprise G, Enterprise G N, Enterprise Multi-session, Education, Education N, Pro, Pro N, Pro Education, Pro Education N, Pro Workstation, Pro Workstation N, IoT Enterprise LTSC 2021-2024 |
| Windows 10                 | Enterprise 2015 LTSB, Enterprise 2015 LTSB N, Enterprise 2016 LTSB, Enterprise 2016 LTSB N, Enterprise LTSC 2019/2021, Enterprise LTSC 2019/2021 N Education, Enterprise, Enterprise G, Enterprise G N, Pro, Pro Education, Pro Workstation, IoT Enterprise LTSC 2021-2024, S (Lean), Remote Server |
| Windows 10 Insider Preview  | Enterprise, EnterpriseN, EnterpriseS, EnterpriseSN, Education, EducationN, Professional, ProfessionalN                                                                               |
| Windows 8.1                 | Enterprise, Enterprise N, Professional, Professional N, Embedded Industry Automotive, Embedded Industry Enterprise, Embedded Industry Professional, Core Connected, Core Connected N, Core Connected Country Specific, Core Connected Single Language |
| Windows 8                   | Enterprise, Enterprise N, Professional, Professional N, Embedded Industry Enterprise, Embedded Industry Professional, Embedded POSReady [Beta] |
| Windows 7                   | Enterprise, Enterprise E, Enterprise N, Professional, Professional E, Professional N, ThinPC, Embedded POSReady, Embedded Standard |
| Windows Vista               | Business, Business N, Enterprise, Enterprise N |

Activates following Volume Licensing versions of **Office**, only **Volume Licensing** SKUs are compatible with this!

| Office Version              | Items                                                                                                                                                                                |
|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Office 2010                 | Professional Plus, Standard, Access, Excel, Word, Powerpoint, Groove, InfoPath, Mondo 1, Mondo 2, OneNote, OutLook, Project Pro, Project Standard, Publisher, Small Business Basics, Visio Premium, Visio Pro, Visio Standard |
| Office 2013                 | Professional Plus, Standard, Access, Excel, Word, Powerpoint, Mondo, OutLook, Lync, InfoPath, Project Pro, Project Standard, Publisher, Visio Pro, Visio Standard                    |
| Office 2013 (Pre-Release)   | Professional Plus, Standard, Access, Excel, Word, Powerpoint, Groove, Mondo, OutLook, Lync, InfoPath, Project Pro, Project Standard, Publisher, Visio Pro, Visio Standard            |


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
