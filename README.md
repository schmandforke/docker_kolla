# Kolla

## Kolla Overview


Kolla's mission statement is:
```
To provide production-ready containers and deployment tools for operating OpenStack clouds
```
Kolla provides Docker containers, Ansible playbooks to deploy OpenStack on baremetal
or virtual machines.

You can use Kolla to generate a Docker Container for each Service within the OpenStack-Stack, as well to deploy the OpenStack Kolla-Stack with a provided Inventory File. For this you will need a working SSH-Connection to each Node.


## Why this container ?
Primary this is a testcase for a PoC where i want to check how conftable it is to deploy and manage Openstack via Kolla.
To use Kolla, you have to install a set of dependencies. You might not want to install a stupid "bootstrap"-VM or install theese dependencies on a Jenkins-Slave, i tried to outsource this framework to a container.

## How to use this container
### General
The docker entrypoint point to a wrapper script which provides a little usage:
```
$ docker run -it --rm kolla:local
ERROR: missing option
Usage: kolla <option> <arguments>

Options:
	build	-> use kolla-build as entrypoint
	deploy	-> use kolla-ansible as entrypoint

Arguments:
provide arguments as you would do by the related Option-Commands, for more info use '--help'
```

### Build
If you want to use this container to generate even more Containers:
for this Action it is needed to have full access to the host docker socket as well as privileged permissions.

```
docker run -i --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock kolla:local build <arguments>
```
You can also provide the set of Build-Templates which you might want to customize:
```
docker run -i --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/config:/etc/kolla kolla:local build <arguments>
```
After this procedure, you will find a lot of containers on the docker host. You can also specify the push method to upload the containers within the build procedure.

### Deploy
You need 3 files for a deployment:

  - /etc/kolla/globals.yml   => config/globals.yml
  - /etc/kolla/passwords.yml => config/passwords.yml
  - /home/inventory/default  => inventory

SSH-Key:
if you want to use an specific ssh key you can specify a docker mount option like: 
```
-v `pwd`/files/id_rsa:/root/.ssh/id_rsa
```
please ensure that your specific key has 0600 permissions !


Initial Deployment:
```
docker run -it --rm --privileged -v `pwd`/files/id_rsa:/root/.ssh/id_rsa -v `pwd`/config:/etc/kolla -v `pwd`/inventory:/home/inventory/default kolla:local deploy -i inventory/default
```

Upgrade Deployment:
```
docker run -it --rm --privileged -v `pwd`/files/id_rsa:/root/.ssh/id_rsa -v `pwd`/config:/etc/kolla -v `pwd`/inventory:/home/inventory/default kolla:local upgrade -i inventory/default
```

## Debugging
You can also start the container with another Entrypoint like this:
```
docker run -it --rm --entrypoint="/bin/bash" kolla:local
```

if you want to generate new crenetials - you can run:
```
docker run -it --rm -v `pwd`/config:/etc/kolla kolla:local genpwd
```
