# SAP NetWeaver AS ABAP Developer Edition 7.52 SP04

## Description

This repository contains a Dockerfile to build a container image for the SAP NetWeaver AS ABAP Developer Edition 7.52 SP04, which is a free version of the SAP NetWeaver Application Server ABAP for development and learning purposes.

## Prerequisites

- Docker installed on your machine
- Sufficient disk space (at least 20 GB) for the Docker image and container
- Access to the SAP NetWeaver AS ABAP Developer Edition 7.52 SP04 installation files, which can be downloaded from the [SAP Developer Center](https://developers.sap.com/trials-downloads.html)

## Installation

To build the Docker image, follow these steps:

1. Clone this repository to your local machine.
2. Download the SAP NetWeaver AS ABAP Developer Edition 7.52 SP04 installation files from the [SAP Developer Center](https://developers.sap.com/trials-downloads.html)
3. Extract all downloaded installation files in the `sapdownloads` directory within the cloned repository. (Using 7zip and selecting all zip files to be extracted in the `sapdownloads` directory is recommended)
4. Open a terminal and navigate to the root directory of the cloned repository.
5. Start with docker compose to build the image and run the container:

```bash
docker compose up -d --build
```

Go to interactive mode and run the installation script:

```bash
docker exec -it sap-abap-752 /bin/bash
cd /tmp/sapdownloads
./install.sh
```

## Usage

Using docker compose is recommended

```bash
docker compose up -d --build
```

## Accessing the Container

Once the container is running, you can access it using the following command:

```bash
docker exec -it sap-abap-752 /bin/bash
```

## Connecting to the SAP System

You can connect to the SAP system using SAP GUI or ABAP in Eclipse.

The default connection parameters are as follows:

- Application Server: `localhost`
- Instance Number: `00`
- System ID: `DE1`
- Client: `001`
- User: `DEVELOPER`
- Password: `Down1oad`

## Troubleshooting

If you encounter issues with the installation script, you may need to convert the line endings from Windows to Unix format. You can do this using the following command:

Into the container, run:

`sed -i 's/\r//' install-quiet.sh`

Dump Database inconsistency: Start transaction SICK.

https://me.sap.com/notes/0003586582

## References

- [SAP NetWeaver AS ABAP Developer Edition 7.52 SP04](https://developers.sap.com/trials-downloads.html)

- [Installing AS ABAP 7.52 SP04 Developer Edition on VMWare and Linux](https://www.sap.com/documents/2019/09/c86f9218-687d-0010-87a3-c30de2ffd8ff.html)

- [Docker Hub (yoraco)](https://hub.docker.com/r/yoraco/sap-dev-edition-7.52-sp04)

Github References:

[sap-abap-dev-edition-docker (daniele-pecora)](https://github.com/daniele-pecora/sap-abap-dev-edition-docker)
