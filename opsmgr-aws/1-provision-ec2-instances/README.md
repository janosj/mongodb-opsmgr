# AWS Provisioning Scripts

Use these scripts to quickly provision the set of EC2 instances to host your Ops Manager demo environment in AWS. Once everything is set up (see Prerequisites) you can launch your instances by running the following command:

> sudo provisionAll.sh 3

That will provision a larger host for your single-node Ops Manager installation, and 3 smaller instances as your agent worker nodes. *Sudo* is required because the script will also update your local */etc/hosts* file, to make it easy to access them without having to lookup the public hostnames or IP address. Instead, you can just connect using the following:

> ssh -i <keyfile> opsmgr-aws
>
> ssh -i <keyfile> agent1

You can specify any base OS image you want, but the examples use RHEL, and the OM installation scripts in this repo are written for RHEL.

## Prerequisites

- Authenticate to AWS, using *awsLogin.sh*. That script requires the AWS CLI - see the script for installation info.

- From this directory, run **npm install** to install the AWS SDK for JavaScript. See [here](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/installing-jssdk.html). The SDK has been added to *package.json*. 


