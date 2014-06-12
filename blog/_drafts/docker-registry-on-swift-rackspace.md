---
layout: news
title: Running a Docker Registry on Rackspace (OpenStack Swift)
author: Hugo Duncan
section: blog
summary: Show how to set up a Docker registry with images stored on Rackspace CloudFiles.  Should work on other OpenStack Swift providers too.
section: blog
---

With [Docker][docker], you can define everything needed to run
applications in a container.  Containers are started based on images,
and images are stored in a registry.

Once you start using docker you will likely want to store your images
somewhere private.  Docker provides a
[public registry][docker-registry-hub], which includes support for
private repositories.  An alternative is to run your own registry.

## Running your own Docker Registry

The [docker registry server][docker-registry] is an open source
project.  The server is of course available as a
[docker image][docker-registry-image], so you can run it in a
container:

```
/usr/bin/docker run --rm \
  -e SETTINGS_FLAVOR=local \
  -p 5000:5000 \
  --name registry \
  registry

```

This will start the registry and expose it on port 5000.

## Using Rackspace CloudFiles to Store Your Images

Storing images inside the container is probably not what you want to
do, as the images will be deleted when the container stops.  The
official registry image provides support for storing files on Amazon
S3, but you have to work slightly harder to use Rackspace CloudFiles,
or some other OpenStack Swift based data store.

The Swift driver for the registry is an
[independent project][docker-registry-driver-swift], which needs to be
added to the official registry image. You can do this with this
[Dockerfile][docker-registry-swift], which is used to create the
[`registry-swift` image][registry-swift] as a docker
[automated build][automated-builds].

To run the image,

```
/usr/bin/docker run --rm \
  -e SETTINGS_FLAVOR=swift \
  -e OS_CONTAINER=docker-registry \
  -e OS_USERNAME=your-username \
  -e OS_PASSWORD=your-password \
  -e OS_AUTH_URL=https://identity.api.rackspacecloud.com/v2.0/ \
  -e OS_REGION_NAME=DFW \
  -e OS_TENANT_NAME=MossoCloudFS_nnnnn \
  -p 5000:5000 \
  --name registry \
  registry-swift
```

To find your tenant name on rackspace, run the following, and examine the (voluminous) json output for the tenant name in the region you want:

```
curl \
    -d '{"auth":{"passwordCredentials":{"username": "myusername", "password": "mypassword"}}}' \
    -H "Content-type: application/json" \
    https://identity.api.rackspacecloud.com/v2.0/tokens
```

[automated-builds]: http://docs.docker.com/docker-hub/builds/ "Docker Automated Builds"
[docker]: http://www.docker.com/ "Docker"
[docker-registry]: https://github.com/dotcloud/docker-registry "Docker Registry"
[docker-registry-hub]: https://registry.hub.docker.com/ "Docker Registry Server on the Docker Hub"
[docker-registry-image]: https://registry.hub.docker.com/_/registry/ "Docker Registry Image"
[docker-registry-driver-swift]: https://github.com/bacongobbler/docker-registry-driver-swift "Docker Registry Swift Driver"
[docker-registry-swift]: https://github.com/palletops/docker-registry-swift "Docker Registry Dokerfile Build with Swift"
[registry-swift]: https://registry.hub.docker.com/u/pallet/registry-swift/ "registry-swift image"
