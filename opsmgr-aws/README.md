# MongoDB Ops Manager: AWS

A collection of scripts and utilities to install Ops Manager (a single-node Ops Manager demo instance) and a set of agent worker nodes in AWS using EC2 RHEL images.

You can provision the EC2 instances any way you want - have a look [here](https://github.com/janosj/utilities/tree/main/provision-aws-hardware) for one option. That provisioning utility also updates your */etc/hosts* file with multiple entries (*opsmgr-aws* and *agent[1-x]*) - subsequent scripts are dependent on these entries.

After provisioning the instances, connect to opsmgr-aws, install git (sudo yum install git), clone this repo, and run the *installOpsMgr* script. Ops Manager is configured for *Local Mode operation*, which means any required MongoDB binaries must be downloaded locally in advance (which is done for you by the *getVersions* script). Ops Manager is configured for SSL using a self-signed certificate. To allow your local browser to accept this certificate, run *get-server-cert* from your local machine and follow the instructions to import it into your local keychain.

After installing Ops Manager, proceed with installing the agents. The agent config files have to be updated with information from Ops Manager. To do this, run the *transfer-agent-config-files* script on your local machine. That will prompt you for the required information from Ops Manager, update the config files, then transfer them via SCP to each agent. Then, ssh into each agent and run *install-agent*. Note that you do not need to install yum or clone this repo on the agents. After running *install-agent* you should see the instances in the *Servers* tab of Ops Manager.

