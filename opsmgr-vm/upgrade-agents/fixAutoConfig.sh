# This was used to fix an issue after upgrading OM to 5.0.
# The Ops Manager configuration lost sync with the installed agent version.
# Containers were eventually shutting down. Agent logs showed the following:
# Failed to change automation version 100 times. Giving up and shutting down. Fatal.
# Then, further down:
# Failed to download new version (10.14.23.6498) of Automation : [15:13:27.912] Error downloading url=http://opsmgr:8080/download/agent/automation/mongodb-mms-automation-agent-10.14.23.6498-1.linux_x86_64.tar.gz : resp=<nil> : Get "http://opsmgr:8080/download/agent/automation/mongodb-mms-automation-agent-10.14.23.6498-1.linux_x86_64.tar.gz": dial tcp 172.17.0.1:8080: connect: connection refused. 

# Issue did not resurface on subsequent upgrade to OM 6.
# Preserved for posterity.

USER="ggjkzcyi" #OM Username
APIKEY="5855797d-5469-4c21-a703-a5a5d08afb3d"
HOST="https://opsmgr:8443"
PROJECTID="5dc701d59b4d0026128370af"
NEWDIRECTORYURL="https://opsmgr:8443/download/agent/automation/"
VERSION="10.2.13.5943-1"

# download the existing agent configuration file:
curl -k -u "$USER:$APIKEY" --digest "$HOST/api/public/v1.0/groups/$PROJECTID/automationConfig" > ./automationConfig.json

#cp automationConfig.json automationConfig-new.json 

#sed -i 's/http:/https:/g' ./automationConfig-new.json
#sed -i 's/8080/8443/g' ./automationConfig-new.json
#sed -i 's/10.14.23.6498-1/11.0.9.7010-1/g' ./automationConfig-new.json

# upload the existing agent configuration file:
curl -k -u "$USER:$APIKEY" -H "Content-Type: application/json" --digest -i -X PUT "$HOST/api/public/v1.0/groups/$PROJECTID/automationConfig" --data @automationConfig-new.json

