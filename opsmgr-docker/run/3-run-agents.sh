source ../env.conf

agent_count=$1

if [ -z "$agent_count" ]; then
    echo "No argument supplied"
    echo "Usage: run-agents.sh <agent-count>"
    exit 1
fi

OM_URL=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ops-manager)

if [[ -z "$OM_URL" ]]; then
    echo "Ops Manager doesn't appear to be running. Exiting."
    echo
#    exit 1
fi

echo "Got OM IP address: $OM_URL. Port is hardcoded at 8080."

echo "Find these next two settings in Ops Manager ..."
read -p "mmsGroupId (the Project ID, from Project > Settings): " MMSGROUPID
read -p "mmsApiKey (from Deployment > Agents > Agent API Keys): " MMSAPIKEY


# Transfer the completed files to all agents.
i="0"
while [ $i -lt $agent_count ]; do

  i=$[$i+1]
  echo
  echo "Launching agent $i ..."

  # parameters _before_ the automation-agent command are docker parameters, 
  # parameters _after_  the automation-agent command are _agent_ parameters.
  # Ports: a set of unique ports is exposed on each agent, which can be used for external connectivity.
  docker run -d --network $DOCKER_NETWORK -p 2702${i}:2702${i} -p 2703${i}:2703${i} -p 3306${i}:3306${i} --name server${i} --hostname server${i}.$DOCKER_NETWORK -t "$AGENT_TAG" /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent --mmsGroupId=$MMSGROUPID --mmsApiKey=$MMSAPIKEY --mmsBaseUrl=http://$OM_URL:8080 -logLevel=INFO

done

echo 
echo "Agent containers deployed!"
echo 

docker container ls

