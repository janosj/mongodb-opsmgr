# Run as root
# Rebuilds the agent containers with the current agent from Ops Manager.
# Ops Manager must be running!
# See notes.

# This download was originally in the Dockerfile, but had to be pulled up, 
# because Docker wasn't able to resolve opsmgr, and it couldn't use the 
# ip address (172.17.0.1), either (probably because of the SSL).

# -k option is a hack to allow self-signed certificate
curl -kOL https://opsmgr:8443/download/agent/automation/mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb

docker build --no-cache -t mongo/automation-agent .

rm ./mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb

