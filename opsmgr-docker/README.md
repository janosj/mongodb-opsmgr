# Ops Manager Demo Environment for Docker

This Ops Manager demo environment uses Docker exclusively, rather than VirtualBox, to circumvent issues with running VirtualBox on newer MacBooks with ARM-based Apple Silicon. Specifically, it was created and verified to work on a 2021 MacBook Pro with an Apple M1 Pro chip.

This is a demo environment only and should not be used in production. If you want to run containerized Ops Manager in production then you should be looking at the MongoDB Enterprise Kubernetes Operator (see [here](https://www.mongodb.com/docs/kubernetes-operator/stable/)).

## Prerequisites

Docker Desktop


## Launching the Docker Ops Manager Demo Environment

The container images have already been built and pushed to Quay.io, so all you have to do is switch to the */run* directory and execute the scripts in order. Note:

- Every script depends on the previous script completing. 

- Ops Manager takes a minute to spin up. This script doesn't ever "complete", per se, as it tails the startup logs.

- *run-agents.sh* is the only script that requires a command-line argument, which is the number of agents you want to spin up. Additionally, the startup script will prompt you for additional information (the Project ID and the API key) that you'll have to retrieve using the Ops Manager UI. When you first access Ops Manager you'll have to create the initial user.

Once you have the required information from Ops Manager, and the *run-agents* script completes, your demo environment is ready. Configuing backup is optional.


#### Configuring Backups

To demonstrate backups (using a blockstore for snapshot storage):

- You need a running backup daemon. This is started automatically by the Ops Manager container.

- You need a running backup database. Use the *start-backup.sh* script to launch another MongoDB database container.

- You need to manually enable and configure backups through the Ops Manager UI. Select *Continuous Backups* on the meu and click through the guided process. A directory for the head db has been created at **/data/headdb**. Configure the Blockstore to connect at **backupdb:27017** (leave all other fields blank).

You should now be able to initiate a backup and demonstrate the recovery process.


## External Database Access

Once Ops Manager is up and running, you'll likely want to deploy a database or two. And you might want to access those databases from your desktop, perhaps using MongoDB Compass or the Mongo shell. To do that, you of course need to specify a connect string, which includes the server name(s) and port(s). Note, though, that all this information is encapsulated within the Docker environment, so some extra steps are required to access it from your desktop:

1: Update your local */etc/hosts* file to include entries for your Agent servers. An entry should look like this:

> 127.0.0.1       server1 server1.opsnet

Now you can specify a ".opsnet" server and your networking will understand that it's actually running on your local machine.

2: Next, it has to redirect your request to the mongod process running in Docker, and it does that is through port mapping. Use the specially designated port in your connect string, and your local networking will know to forward requests to the mongod processes running in Docker. What port to use? The *docker run* command in *run-agents.sh* includes a port mapping. You can adjust this to suit your needs, but as written here you can deploy Mongo on port 27021 on server1, 27022 on server2, an so on, and then specify that port in your connect string from Compass, the shell, or your client-side tool of choice. For added flexibility, two additional port mappings are included: 2703x and 3306x.


## Tearing Down and Re-Running the Images

The *stop-image.sh* script will stop any running containers, and also remove them. This ensures that there are no hidden Docker artifacts on your system, and your environment will come up clean the next time you run it. For example, if an old AppDB container is sticking around when you restart Ops Manager, you'll see an error about a mismatched encryption key and you'll have to start over. When in doubt, stop all containers and run "docker system prune".

Assuming you don't remove the images from your local system ("docker image rm"), subsequent startups will complete much more quickly, as they won't have to be downloaded from Quay. 


## Building the Images

As indicated above, the Ops Manager and Agent images have been posted to Quay (and the MongoDB image is the standard image), so you normally shouldn't have to rebuild any images local. But you can if you want to - everything is included in the */build* directory. Note:

- The AppDB image is just a generic MongoDB container image. No customizations are required and therefore there are no build scripts.

- Build the Ops Manager image first (i.e. before building the agent). Simply go into the directory and execute the *build-om-image.sh* script.

- The Agent image should be built next, but there's some awkwardness at this point: the latest Agent binary is pulled, actually, from a running Ops Manager instance. So before you build the agent Image, you have to start the Ops Manager container (see above, and note that you'll have to first start the network and AppDB). With Ops Manager running, simply go into the Agent build directory and run *build-agent.sh*. 


## Configuration Settings

The *env.conf* file is configured to automatically pull the latest demo OM image from Quay. Assuming you're okay with that, you won't have to modify any of the settings. If you want to run an earlier version of Ops Manager, you can. Or you might want to update the version of the AppDB.

Otherwise, everything in here has to do with building the images:

1. Specify your OM version and its download URL. Note [here](https://www.mongodb.com/docs/ops-manager/current/core/requirements/#operating-systems-compatible-with-onprem) that Ops Manager doesn't officially support ARM, so the download URL is not architecture specific. These scripts are wired to use the Amazon Linux 2 operating system, because it didn't exhibit any of the issues that cropped up with Amazon Linux 2023, or the (different) ones that cropped up with Ubuntu.

2. Specify the ARM64 JDK download URL. The x86 JDK will be replaced. 

3. Specify the version of MongoDB to use for the AppDB. Consult the AppDB compatibility matrix ([here](https://www.mongodb.com/docs/ops-manager/current/tutorial/prepare-backing-mongodb-instances/#use-a-compatible-mongodb-version)).


## Credits

This repo was adapted from Mihai Bojin's repo, available [here](https://github.com/mongodb-labs/omida/tree/main). 

Agent containers were added based on some work originally done by Paul Done (for use with VirtualBox).

