#!/bin/bash
# Run this script using 'sudo' to create some automation agent containers, e.g.:  > sudo ./start_containers.sh

NUMBER_TO_CREATE=3
PROJECTID=5dc701d59b4d0026128370af
APIKEY=5f5fa96dfb107b09cd2d32608f8ca667eb2bf4f411d6f42080279b72

echo 

if [[ $EUID -ne 0 ]]; then
  echo "ERROR: Please run script with sudo"
  echo 
  exit 1
fi

ADD_HOST_LIST_PARAMS="--add-host opsmgr:172.17.0.1"

# Build list of hostname/ip-address mappings representing ops mgr host + all containers, ready to then be passed to each container created - also adds hostname/ip-address mappings to /etc/hosts of VM
for i in $(seq 1 $NUMBER_TO_CREATE)
do
    octet=$((i+1))
    ADD_HOST_LIST_PARAMS="${ADD_HOST_LIST_PARAMS} --add-host myserver${i}:172.17.0.${octet}"
    echo "172.17.0.${octet}  myserver${i}" >> /etc/hosts
done

# Loop creating a set of Docker containers
for i in $(seq 1 $NUMBER_TO_CREATE)
do
    cmd=" docker run -p 2702${i}:2702${i} -p 2703${i}:2703${i} -p 3306${i}:3306${i} "${ADD_HOST_LIST_PARAMS}" --hostname=myserver${i} -d --name automation-agent-container${i} -t mongo/automation-agent /opt/mongodb-mms-automation/bin/mongodb-mms-automation-agent --mmsGroupId=${PROJECTID} --mmsApiKey=${APIKEY} --mmsBaseUrl=https://opsmgr:8443 -httpsCAFile=/etc/mongodb-mms/opsmgrCA.pem  -logLevel=INFO -logFile=/var/log/mongodb-mms-automation/automation-agent.log"
    eval "${cmd}"
done

echo 
echo "${NUMBER_TO_CREATE} containers running Ops Mgr Automation Agents should have started - check output below (/etc/hosts has also been added to)"
echo
docker ps -a
echo 

