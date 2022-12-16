# Run as root

# This had to be pulled out of the Dockerfile, because Docker wasn't able to resolve opsmgr,
# and it couldn't use the ip address (172.17.0.1), either (probably because of the SSL).
# -k option is a hack to allow self-signed certificate
curl -kOL https://opsmgr:8443/download/agent/automation/mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb

docker build --no-cache -t mongo/automation-agent .

rm ./mongodb-mms-automation-agent-manager_latest_amd64.ubuntu1604.deb

