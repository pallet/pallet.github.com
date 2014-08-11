---
layout: main/blog-post
title: Run clojure projects on Docker with lein-uberimage
author: Antoni Batchelli
section: blog
permalink: blog/lein-uberimage
categories: [docker,news]
---

We built a lein plugin to make it easy to run clojure projects in Docker containers. This article first introduces containers and Docker, and then shows how you can effortlessly create such containers for your Clojure projects with `lein uberimage`. 

<image src="/images/docker-large-h-trans.png" alt="Docker logo" class="img-responsive">

## Why Containers and Why Docker

A container is a lighweight form of computer virtualization. Containers run within a host, and a host can run many containers concurrently. Each container is functionally equivalent to a computer loaded with a full OS, but behind the scenes all containers in the same host are sharing the same host resources: kernel, memory, IO, and disk.

There are many ways of virtualization technologies used today, VirtualBox, Xen (used by Amazon Web Services) and vmware to name a few, but what makes containers special is their lightweight nature. Each container uses very little resources (disk, memory, cpu) and they all boot orders of magnitude faster than a virtual machine or
a computer.

Containers are very convenient for both development and production environments. For development, they provide a fast and simple way to run different and isolated runtime environments for each application. In production, they are very fast and efficient, with the added bonus that containers in production always match the ones in development; the same exact containers are used during all app's lifecycle.

[Docker][docker] is a novel container technology for Linux that provides a very low friction access to containers. Containers have been around for a while, and the Linux kernel has provided key container technologies for a while already. Docker wraps all these kernel features under a high level API and defines a standard container and image formats using union filesystems. To make containers easy to share and distribute, Docker also provides public and private image repositories. All these features have brought containers to the masses.

Although Docker is currently Linux only, you can use it on OSX installing [boot2docker][boot2docker]

[boot2docker]: http://boot2docker.io
[docker]: http://www.docker.com

For a more detailed introduction to Docker, check out this video on [sysadmincasts.com](http://sysadmincasts.com/episodes/31-introduction-to-docker).

## Docker images

Each container is a process tree that is started from an existing image. These images contain a filesystem with the files necessary to run your application. Sometimes this entails a linux distribution and sometimes just one statically linked binary. The common practice in the Docker world is to build a custom image for each type of service you intend to run. This contrasts with other forms of virtualization where you start the VMs from a base image and then you configure them with the required software. In the case of VMs, the time it takes a VM to boot until it is ready to run your application is measured in minutes, whereas in Docker a container can boot in sub-second times.

## Building Docker images with uberimage

`lein-uberimage` builds a Docker image for clojure projects. The generated images contain a base operating system, a java runtime, and your project's `uberjar`. Once this image is built, you can instantiate as many containers as you need using this image, each container running your `uberjar`.

At the time of writing this, `lein-uberimage` requires that the project builds with `lein uberjar` and that the resulting jar can be run via `java -jar <your-uberjar>.jar`. This means your `project.clj` will have to have a `:main` entry pointing to the `-main` function in your code. This restriction will be removed in the future.

To build the Docker image for your project, run the following in your project's root:

``` bash
$ lein uberimage
```

`uberimage` will call lein's `uberjar` to build the standalone jar file. Then it will build a new image with `Ubuntu 14.04`, `OpenJDK 7` and the freshly built jar. The image is also configured to run your jar file on boot. This task will return the `uuid` for this image.

From this image you just created, you can spawn as many containers as you need. The most basic way to start a container is this:

``` bash
$ docker run <my-image-uuid>
```

In most cases, your app won't be useful unless you can access it via known ports, and by default, Docker does not expose any ports of a container, so you need to tell Docker to expose those ports. Since you will be running many containers on the same host you need to ensure that not two containers are bound to the same port. For example, if your application listens on port 3000, you need to tell Docker to bind the container's port 3000 to any unbound port in the host, e.g. 8080:

``` bash
$ docker run -p 3000:8080 <my-image-uuid>
```

Once the container has started, just head over to `http://<docker-host>:8080` to access your newly deployed service. If you launch a second container with the same image, you cannot bind it to the same host port (8080 in this case) and you should instead map it to port 8081 `docker run -p 3000:8081 ...`.

## Trying It Out

  * [Install](https://docs.docker.com/installation/#installation) Docker.
  * Clone this [example clojure project](https://github.com/tbatchelli/compojure-example).
  * On the project root, run `lein uberimage` and copy the supplied image uuid
  * At the shell, run `docker run -d -p 3000:3000 <image-uuid>`
  * Open the browser and head on to `http://<docker-host>:3000`. Docker-host could be `localhost` in case you are in linux, or the boot2docker IP address if you are using boot2docker.
  * Run `docker run -d -p 3001:3000 <image-uuid>` to run a second instance and check `http://<docker-host>:3001` with your browser. Notice the different IP address.

## Additional Options

In case the supplied OS and java versions are not what you're looking for, you can supply your own base image to `lein-uberimage`:

``` bash
$ lein uberimage -b <your-image-with-jvm>
```

And in case your Docker is not locally installed on the default port or it is remote, you can override its url:

```bash
$ lein uberimage -H http://<host>:<port>
```

## Concluding remarks

There is not much more to it for now. This is our first stab at helping clojurians leverage containers. Please submit bugs and ideas to our project's [Issues](https://github.com/palletops/lein-uberimage/issues) or drop by our chatroom [#pallet](http://webchat.freenode.net/?channels=pallet) on freenode.


`lein-uberimage` is build on top of [clj-docker][clj-docker], a clojure wrapper over docker.

[clj-docker]: https://github.com/palletops/clj-docker.
