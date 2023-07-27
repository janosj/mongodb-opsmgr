# Installing the Agents

From your local machine, run the *transfer-agent-config-files.sh* script update the agent configuration settings and transfer the pre-configured agent package to each of the agent EC2 instances. In this case of 3 agents, you would run the following:

> ./1-transfer-agent-config-files.sh 3

The scripts prompts you for the required information, which can be obtained from the Ops Manager UI. When you access Ops Manager for the first time you'll have to Sign Up the initial user. 

- Ops Manager Internal IP. You can get this information from the AWS console. 

- mmsGroupID: Find this value at Project > Settings > Project ID.

- mmsApiKey: Click "Manage Agent API Keys" and "Generate". Copy the API key. 

Now ssh to each of the agents :

> ssh -i <path-to-key> ec2-user@agent1
> sudo ./install-agent.sh

At this point, the agents should be running and connecting to Ops Manager. Within the Ops Manager UI, navigate to Servers and verify that the expected number of nodes are shown.


