source ../../env.conf

DEFAULT_OM_PORT=8080

# Verify Ops Manager is running.
om_status=$(docker ps -q -f name="ops-manager")
if [ -z "$om_status" ]; then
    echo
    echo "It doesn't look like Ops Manager is running (at http://localhost:$DEFAULT_OM_PORT)."
    echo "This container buildfile uses Ops Manager to grab the latest agent."
    echo "Can't proceed. Start OM and then rerun this script. Exiting."
    echo
    exit 1
fi

echo 
echo "Downloading latest agent from OM..."

curl -Lo downloaded-agent.aarch64.amzn2.rpm http://localhost:$DEFAULT_OM_PORT/download/agent/automation/mongodb-mms-automation-agent-manager-latest.aarch64.amzn2.rpm

docker build --no-cache -t "$AGENT_TAG:latest" .

