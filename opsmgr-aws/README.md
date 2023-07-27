# MongoDB Ops Manager: AWS

Deploys a MongoDB Ops Manager demo environment on AWS using EC2 instances. The demo environment consists of a single-node Ops Manager installation and a configurable number of agents. 

The provisioning directory provides command-line tools to easily spin up the required EC2 instances. 

Once they are available, connect to *opsmgr-aws* (which should have been added to your /etc/hosts file), install git (*sudo yum install git*), clone this repo, and run the *installOpsMgr* script. Ops Manager is configured for *Local Mode operation*, which means any required MongoDB binaries must be downloaded locally in advance (which is done for you by the *getVersions* script as part of the installation). Ops Manager is configured for SSL using a self-signed certificate. To allow your local browser to accept this certificate, run *get-server-cert* from your local machine and follow the instructions to import it into your local keychain.

After installing Ops Manager, proceed with installing the agents. The agent config files have to be updated with information from Ops Manager. To do this, run the *transfer-agent-config-files* script on your local machine. That will prompt you for the required information from Ops Manager (i.e. the project ID and the API key), update the config files, and then transfer them via SCP to each agent. ssh into each agent and run *install-agent*. Note that you do not need to install yum or clone this repo on the agents, as everything that's required was bundled up before the transfer. After running *install-agent* you should see the instances in the *Servers* tab of Ops Manager.

