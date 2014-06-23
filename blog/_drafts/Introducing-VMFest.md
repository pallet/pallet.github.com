---
layout: main/post
title: Automate VirtualBox with VMFest for Fun and Profit
author: Antoni Batchelli
section: blog
summary: TBD
---


Over a year ago Hugo and I were looking for a way to speed up our
development of Pallet. We identified testing, both at development time
or at integration time to be the major speed issues. We set out to
find a way to quickly test Pallet that didn't cost us a fortune in
cloud hours. We defined our ideal solution as something that behaved
just like a cloud provider but would be able to run on our laptops.

We started looking at VirtualBox --a virtual machine platform--
because is lightweight and free. VirtualBox's operations can also be
be automated via its public API. But these were all the good news. The
bad news were that this API is complex, sometimes not well
documented, and other times just plain odd.

We realized that our goal of speeding up Pallet development required
to first tame VirtualBox. The result is VMFest, a library to create,
start, pause, resume, stop, and destroy VirtualBox virtual machines.
VMFest keeps all the ugly bits of dealing with the VirtualBox API
under the rug, something that will surely make you a happier person.


Enter VMFest
------------

Without much ado, this is how you create a VM in VMFest:

``` clojure
(use 'vmfest.manager)
(def my-server (server "http://localhost:80183"))
(def my-machine
 (instance
   my-server
   "my-new-vm"
   {:memory-size 512
    :cpu-count 1
    :network [{:attachment-type :nat}]
    :storage [{:name "IDE Controller"
               :bus :ide
               :devices [nil nil {:device-type :dvd} nil]}]
    :boot-mount-point ["IDE Controller" 0]}
   {:uuid "..../image.vdi"}))
```

Now, I am sure you might want to use this machine, so let's start it:

``` clojure
(start my-machine)
```

If all you wanted to do is create and operate VMs, this is pretty much
it for you. If instead you want to tinker, read on.

Automating VirtualBox
---------------------

From the beginning we wanted to be able to use VirtualBox remotely.
VirtualBox offers two SDKs for controlling the host from the JVM, both
of them implementing the same API. One is for local access and is a
wrapper around the XPCOM objects that form VirtualBox. The other is
for remote access and consists of a server running in the remote host.
This server wraps the local XPCOM objects with a Web Services layer,
SOAP in this case. VirtualBox a version of the SDK that wraps this
SOAP layer for the client. We chose going the web services way because
of the ability to control remote hosts with it.

Even though VirtualBox is a rather simple product but its API is
complex. To make matters worse, using a remote API and the design of
the API itself made building an automation library more complex than
it should be. These issues had a big part in the design design
decisions in VMFest. Here is an incomplete list of the issues we
found:

### You think you destroyed this object? You didn't.

When using the remote SDK, creating a local object --for example a new
VM-- will result in a new object created in the remote host. You are
responsible to ensure they are deleted or face an "Out of Memory"
error rather quickly --the remote host will not delete any object when
the local counterpart is garbage collected.
  
### You think you got the gist of this API? You didn't.

The API is not orthogonal. The same kind of operation is done very
differently in different parts of the API.
  
### You think you can change the settings on this VM? You can't

To manage a VM, you need to obtain a lock on that VM. There are 3
different types of lock and different operations will require
different locks. Also, some locks are exclusive and others are not.

### You thought you were talking to the host? It closed your connection

When using API objects, the connection to the server must be live. If
the connection is broken you will not be able to read the fields of
your objects.

### You think E_INVALID_OBJECT means the object is not valid? Not this time.

NOTE: Title no good

Methods in the API return error codes when something goes wrong, but
the same error code can have different meaning in different method
calls.

### You thought your code would last long? It won't.

 The major and minor version numbers are encoded in the name of the
  java packages, e.g.:
  ``` clojure
  org.virtualbox_4_1 
  ```

Designing for VBox's Remote API
-------------------------------

### Dealing with the Object/Proxy duality

When you create objects via the API, what you are effectively doing is
creating a remote object and a local proxy for that object. This has
implications at two levels:

First of all, when you stop using the local proxy, the JVM will
garbage collect it, but not so the remote object. The remote objects
can either be removed explicitly, they can be timed out by the server,
or they are removed when the connection to the server is closed. Not
removing the objects will quickly lead to running out of memory on the
server side. Explicit removal of objects would litter the code with
defensive code to ensure all objects are removed. Having the server
time out unused objects would lead to the code having to check for
object validity before each use. We're left with closing the
connection as a mean to clean up unused remote objects, and the way we
chose to leverage this option is to close the connection often.
   
The second issue is that the local objects are only functional if
there is a running connection. If this connection is lost, all the
local objects are broken and using them will result in error. We opted
for creating a new session right before we are going to use it, and
closing it shortly afterwards.

This second issue has a corollary. Let's say we open a session and
create a VM, then we close the session. How do we keep track of the VM
after the session is closed? We need means to move between the world
with a session and the world without one.
   
   


