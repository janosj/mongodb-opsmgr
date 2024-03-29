# Installing the Single-Node Ops Manager Demo Instance

These scripts will install a Simple Test Ops Manager Installation, as described in the Ops Manager product documentation [here](https://www.mongodb.com/docs/ops-manager/current/tutorial/install-simple-test-deployment/). After provisioning an EC2 instance to host Ops Manager:

- ssh to the node at *opsmgr-aws* (your local */etc/hosts* file should have been updated). 

- Install git (*yum install git*) and clone this repo. 

- Switch to this install directory and run the *installOpsMgr* script. 

When the script completes, Ops Manager should be up and running. Note the following:

- The installation script configures Ops Manager for *local mode operation*, meaning the versions of MongoDB version that you want to deploy must be downloaded locally in advance (which is done for you by the *getVersions* script as part of the installation). 

- Ops Manager is configured for SSL using a self-signed certificate. To allow your local browser to accept this certificate, run *get-server-cert* from your local machine and follow the instructions to import it into your local keychain. Test connectivity by accessing the Ops Manager UI at *https:opsmgr-aws:8443*. With the certificate imported correctly, you should no longer see an ERR_CERT_AUTHORITY_INVALID warning in the "Your connection is not private" page. 

Next, proceed with installing the agents.


