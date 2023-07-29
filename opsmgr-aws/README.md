# Ops Manager Demo Environment for AWS

Deploys a MongoDB Ops Manager demo environment on AWS using EC2 instances. The demo environment consists of a single-node Ops Manager installation and a configurable number of agents. To deploy the environment:

1. Provision the EC2 instances.

2. Deploy Ops Manager.

3. Deploy the Agents.

4. Configure backup. 

Details for steps 1 through 3 can be found in their respective folders. To configure backup:

- In the Ops Manager UI, select Continuous Backup and then click *configure the backup module*. 

- Set the HEAD directory to */data/headdb*. That directory was created during OM installation. 

- Click **Enable Daemon**.

- Click **Configure a Blockstore**

- For hostname and port, enter **localhost:27018**. The other fields can be left blank. Click **Save**, then **Back to Project**.

Also from the Ops Manager UI, in the Servers pane, activate Monitoring and Backup on all Servers.

