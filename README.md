# 🦆 Rubberverse Containers

Hiya, this is a personalized fork of py-kms for my LAN. It will have some bigger changes *eventually* (I'm busy with other things and that day may never come. Oh well.)

![repo-size](https://img.shields.io/github/repo-size/Rubberverse/qor-kms) ![last-commit](https://img.shields.io/github/last-commit/Rubberverse/qor-kms/next)

## Mandatory warning (because some of you are reckless)

> [!WARNING]
> Only use this software in a private setting. Never open it up to internet, unless you wanna get striked down by Microsoft. Using this software in official, company setting is a violation of Microsoft license agreement.

Yes, who would've thought that an emulator that anyone could connect to and easily activate their copy without it requiring any extra verification (KmsKey) would be punishable by law? Anyhow, just keep it on your LAN, no one will care. If Microsoft can't take down some KMS server, they'll blacklist it so unless you wanna be a piece of history in their source code, maybe don't do that.

No this is not piracy, we are just doing what Microsoft does with their AI garbage and it is... free-use. No, I don't mean *that* kind of free use, I mean it's free for grabs for anyone! Torrent it all, download it, feed it into an oversized beast that sinks power through a straw! 

*If a big corporation can do it then so can you!!!* 

It's only fair if that's how everyone is going to respect copyright law, eh? Rants aside, don't buy a Windows license as a legit user since you'll be stuck calling their hotline everytime you dare to move even a single part in your PC and it's main reason why people use scripts like MAS to begin with. Though if you ever bought a laptop or any OEM certificed device then... you already paid for a Windows license indirectly. Why pay again? Why spend those $300 just to have your key suddenly run out of uses because you dared to *gasp* swap a hard drive out of your pc, making it appear as a new one to Microsoft! You're a thief!!!

Maybe I'm just too annoyed at this and I'm using GitHub Readme for a goofy emulator project to have an insane rant for no reason... it is what it is.

## 😕 Another one of these?

Yep, because I want something that I can maintain myself. It's also easier for me to troubleshoot a problem and find out why something happens... and also because I want bare minimum image.

### 🍴 This is current changelog compared to upstream

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
- Database: Updated `KMSDatabase.xml` with latest (well it was latest when this was written) License Manager 5.1 changes, declutterified it to enhance py-kms performance and give it better reliability long-term (v2.0)

Maybe that actually does something, who knows. Hopefully now it activates all VL Windows and Office versions, if not then I missed some value somewhere.

### 🔨 Planned fork changes

ToDo list if you will.

- [ ] Replace `start.py` and `healtcheck.py` with `sh` scripts, or maybe something more "bare".
- [ ] Maybe move it to a scratch base?
- [ ] Simplify environmental variables
- [ ] Better descriptions for database entries
- [ ] Make front-end better
- [ ] Better documentation for KmsDataBase.xml
- [ ] Unclutter KmsDataBase.xml further
- [ ] i18n support? Maybe?? Perchance???

### Image tags

There are container images built and hosted under packages here, you can pull them if you want.

I'm too lazy to put it here right now, you'll find it I believe in you!

### How to manually update KmsDataBase.xml

Generally, all you need to add a new entry to the list is:

1. Install a valid copy of a Volume Licensed SKU product (Windows or Office)
2. Read it's ActivationID and SkuID off relevant pkeyconfig (Beware, there are a lot of Skus! You will need to pick the correct Volume one. You can also have some fun and add Lab Sku too while at it since those entries are always present in pkeyconfig)
3. Add those values to `KmsDataBase.xml`

For Windows, those pkeyconfigs will be located in following directiories:

- ActivationID (from ActKeyConfigId table) - `C:\Windows\System32\app\tokens\pkeyconfig\pkeyconfig-csvlk.xrm-ms`
- SkuID (from ActKeyConfigId table) - `C:\Windows\System32\app\tokens\pkeyconfig\pkeyconfig-downlevel.xrm-ms`

`<WinBuilds>` is only used during key generation, if you want to reduce the size then only add server relevant PlatformIDs as those only really matter. Haven't tested it to see if removing anything else will make it break but you can experiment around and let me know.

`<CSVLK>` entry is where you want to put your newly acquired ActivationID in. 

`ReleaseDate` can be whatever, in fact it would be good to even get rid of it altogether as py-kms doesn't seem to need it. 

`VlmcsdIndex` honestly I forgot I'll edit this later when I figure out what it does again. 

`GroupID` should correspond to the GroupId given in pkeyconfig, Min and MaxKeyId generally don't matter but it's a good practice to make them match with what pkeyconfig reports. 

`Id=""` should be your ActivationId that you've gotten off pkeyconfig.

It is unnecessary to add a specific EPid to a product, unless you experience activation errors due to it expecting certain value. You can get by just leaving it at blank which by default will generate a randomized EPid for each new request.

```xml
<CsvlkItem DisplayName="Windows Server 2019 (Azure Only)" ReleaseDate="2018-10-02T00:00:00Z" GroupId="206" IniFileName="Windows" Id="3c006fa7-3b03-45a4-93da-63ddc1bdce11">
    <Activate KmsItem="UUID" />
</CsvlkItem>
```

For KmsItem, read my comment below:

```xml
<!---
            <KmsItem Id=""> is referenced by <Activate Id=""> in <CsvlkItem>
            It can be a random GUID or UUIDv5 value.
            Take a look at Windows Server 2025, it's GUID is 4b83307d-7788-50ff-8d1f-1861915bdb9d and if you scroll up to CsvlkItem entry for it, 
            you will see an activate entry with the same Id. <Activate KmsItem=""> is supposed to point to an <KmsItem> entry in <AppItems>
-->
```

This portion is also how entries show up on overview dashboard so you can customize it if you want, just don't go too crazy as it's pretty fragile.

After you're done with all that manual work, you can mount your new KmsDataBase.xml to your container, restart it and try activating your desired product. If it activates, great! Try activating your another copy again to ensure that some regression didn't happen. If all works fine, you've successfully updated KmsDataBase.xml!

**Note about porting License Manager KmsDataBase.xml**: Please, pleaaaseee do NOT just copy and paste it in! It will confuse py-kms due to duplicated entries in every single `<CsvlkItem>` block. License Manager can handle it because it was built for it, this will however make most licensing request take too long or time out on py-kms. Cherry-pick `CsvlkItem` property and `KmsItem` property, add them to your file and you don't have to worry about anything else anymore.

## py-kms silently failing after modifying Dockerfile (no activation)

This is an annoying problem with programs not logging their own execution error messages. This can be fixed by making sure that **every .py file inside py-kms directory has Read and Execute permissions.** Without them, it will silently fail and you'll get that dreadful message back about Activation server not responding.

Yeah, the issue wasn't Python version. It's just that recent Python versions don't seem to ignore executable permissions anymore, or rather some distros do, so they will fail and burst into flames.

### 🤔 What products can it activate?

It can activate about *most* things that are **Volume Licensed**. However, products using MAK VL are **incompatible** because that's just completely different thing. Mass Activation Keys are supplied by Microsoft and are alternative to KMS, they activate like a retail key would but instead are well, mass volume. 

When it comes to py-kms, as long as it can handle the activation request then if there's a valid ActivationID and SkuID - it will activate it. We don't know if MS will update it or not so it may break in future unless somebody picks up and updates Py-KMS for that.

Anyhow, here's what it can activate.

| VL Version         | SKUs                                                                                                           |
|--------------------|----------------------------------------------------------------------------------------------------------------|
| Windows Server 2025 | Azure Core, Datacenter Azure Edition, Datacenter, Standard         |
| Windows Server 2022 | Azure Core, Datacenter Azure Edition, Datacenter, Standard         |
| Windows Server 2016 | Azure Core, Essentials, Datacenter, Standard, ARM64, Cloud Storage |
| Windows Server 2012 R2 | Essentials, Datacenter, Standard, Cloud Storage                 |
| Windows Server 2012    |  Essentials, Datacenter, Standard, MultiPoint Premium, MultiPoint Standard |
| Windows Server 2008 R2 A | MultiPoint Server 2010, Web, HTPC Edition |
| Windows Server 2008 R2 B | Standard, Enterprise                      |
| Windows Server 2008 R2 C | Datacenter, Enterprise for Itanium        |
| Windows Server 2008 A    | Web, Computer Cluster                     |
| Windows Server 2008 B    | Standard, Enterprise                      |
| Windows Server 2008 C    | Datacenter, Datacenter without Hyper-V, Enterprise for Itanium |
| Windows Server Next      | Preview Datacenter, Preview Standard, Preview Web, Preview ServerHI |
| Windows 11         | Enterprise, Enterprise N, Enterprise G, Enterprise G N, Enterprise Multi-session, Education, Education N, Pro, Pro N, Pro Education, Pro Education N, Pro Workstation, Pro Workstation N, IoT Enterprise LTSC 2021/2024, S (Lean), Remote Server |
| Windows 11 Insider | Enterprise, Enterprise N, Enterprise G, Enterprise G N, Enterprise Multi-session, Education, Education N, Pro Education, Pro Education N, Pro Workstation, Pro Workstation N |
| Windows 10         | Enterprise 2015 LTSB, Enterprise 2015 LTSB N, Enterprise 2016 LTSB, Enterprise 2016 LTSB N, Enterprise LTSC 2019/2021, Enterprise LTSC 2019/2021 N Education, Enterprise, Enterprise G, Enterprise G N, Pro, Pro Education, Pro Workstation, IoT Enterprise LTSC 2021-2024, S (Lean), Remote Server, ServerRdsh |
| Windows 10 Insider | Enterprise, EnterpriseN, EnterpriseS, EnterpriseSN, Education, EducationN, Professional, ProfessionalN  |
| Windows 8.1        | Enterprise, Enterprise N, Professional, Professional N, Embedded Industry Automotive, Embedded Industry Enterprise, Embedded Industry Professional, Core Connected, Core Connected N, Core Connected Country Specific, Core Connected Single Language |
| Windows 8           | Enterprise, Enterprise N, Professional, Professional N, Embedded Industry Enterprise, Embedded Industry Professional, Embedded POSReady [Beta] |
| Windows 7          | Enterprise, Enterprise E, Enterprise N, Professional, Professional E, Professional N, ThinPC, Embedded POSReady, Embedded Standard |
| Windows Vista      | Business, Business N, Enterprise, Enterprise N |
| Office LTSC 2024   | LTSC Professional Plus, LTSC Standard, Access LTSC, Excel LTSC, Word LTSC, Powerpoint LTSC, Outlook LTSC, Skype for Business (Lync) LTSC, Project Pro, Project Standard, Visio LTSC Pro, Visio LTSC Standard |
| Office LTSC 2024 Preview | Professional Plus Preview, Project Pro Preview, Visio Pro Preview |
| Office LTSC 2021   | LTSC Professional Plus, LTSC Standard, Access LTSC, Excel LTSC, Word LTSC, Powerpoint LTSC, Outlook LTSC, Skype for Business (Lync) LTSC, Project Pro, Project Standard, Publisher LTSC, Visio LTSC Pro, Visio LTSC Standard |
| Office LTSC 2021 Preview | Professional Plus Preview, Project Pro Preview, Visio Pro Preview |
| Office 2019        | Professional Plus, Standard, Access, Excel, Word, Powerpoint, Outlook, Skype for Business (Lync), Project Pro, Project Standard, Visio Pro, Visio Standard |
| Office 2019 Preview | Professional Plus Preview, Project Pro Preview, Visio Pro Preview  |
| Office 2016         | Professional Plus, Standard, Access, Excel, Word, Powerpoint, Mondo, Mondo R, Outlook, Skype for Business (Lync), Project Pro, Project Pro C2R, Project Standard, Project Standard C2R, Publisher, Visio Pro, Visio Pro C2R, Visio Standard, Visio Standard C2R |
| Office 2013         | Professional Plus, Standard, Access, Excel, Word, Powerpoint, Mondo, OutLook, Lync, InfoPath, Project Pro, Project Standard, Publisher, Visio Pro, Visio Standard |
| Office 2013 Pre-Release | Professional Plus, Standard, Access, Excel, Word, Powerpoint, Groove, Mondo, OutLook, Lync, InfoPath, Project Pro, Project Standard, Publisher, Visio Pro, Visio Standard |
| Office 2010         |  	Professional Plus, Standard, Access, Excel, Word, Powerpoint, Groove, InfoPath, Mondo 1, Mondo 2, OneNote, OutLook, Project Pro, Project Standard, Publisher, Small Business Basics, Visio Premium, Visio Pro, Visio Standard |

Enterprise G, Enterprise G N is known as China Government, Enterprise multi-session is known as ServerRdsh VL

### Network Ports

> [!IMPORTANT]
> Use `IP` environmental variable to enable IPv6 support if you require it. To do so, you set the environmental variable to following value `IP=::`. Otherwise, it will listen only on IPv4.

Following ports are used inside of the container:

- 1688/tcp for KMS server
- 8080/tcp for Web Server (Overview)

If you need different web ports, use `--publish` in podman run command, `PublishPort=` in Quadlet, or `Ports:` in Docker Compose. Relevant docs for Podman: [podman run](https://docs.podman.io/en/latest/markdown/podman-run.1.html#publish-p-ip-hostport-containerport-protocol), [systemd-unit](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#container-units-container), [Docker Compose](https://docs.docker.com/get-started/docker-concepts/running-containers/publishing-ports/#use-docker-compose)

```bash
podman run -d localhost/py-kms:latest -p 127.0.0.1:9012:8080/tcp
```

### Quadlet

> [!WARNING]
> Quadlet functionality is only available since Podman version 5.2+. This feature is not present on Docker.

In case you want to let the container process fix up the permissions by itself, you can pass `U` flag to the `Volume=` argument. This is easiest way to solve permission problems with rootless containers.

```conf
Volume=%h/AppData/2_PERSIST/PYKMS:/app/db:rw,Z,U
```

Here's a full config, based on my home one.

1. Copy and paste it into a file in `~/config/containers/systemd/pykms.container`
2. Reload systemd `systemctl --user-daemon-reload`
3. Create `Appdata` directory - `mkdir -p ~/Appdata/KMS`
4. Start the service `systemctl --user start pykms`

```cfg
[Unit]
Description=Key Managment Service (unofficial) - Used for Windows & Office activations

[Install]
WantedBy=default.target

[Service]
Restart=on-failure
SystemCallArchitectures=native
MemoryDenyWriteExecute=false

[Container]
Image=ghcr.io/rubberverse/qor-kms:latest
ContainerName=rvs-kms
Environment=KMS_IP=0.0.0.0
# Volumes + shim
Volume=%h/Appdata/KMS:/app/db:U,Z
Tmpfs=/dev/shm
# Labels
NoNewPrivileges=true
DropCapability=all
ReadOnly=true
# Network
# SRV _vlmcs._tcp.<domain>
PublishPort=1688:1688/tcp
# User
UserNS=auto:size=1003
```

Now you have a container listening on `1688/tcp` for any KMS activation requests.

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



