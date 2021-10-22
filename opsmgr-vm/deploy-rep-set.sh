#!/bin/bash

PUBLIC_API_KEY="d5151d4d-62b3-4606-8382-3e200873a660"
PROJECTID="5dc701d59b4d0026128370af"

USERID="admin@mongodb.com"
OPSMGR_HOST="localhost:8080"

printf "\n----AUTOMATION STATUS BEFORE ENABLING MONITORING & BACKUP AGENTS AND DEPLOYING REPLICA SET\n\n"
curl --user "${USERID}:${PUBLIC_API_KEY}" --digest --include --header "Accept: application/json" --request GET "http://${OPSMGR_HOST}/api/public/v1.0/groups/${PROJECTID}/automationStatus?pretty=true"
printf "\n\n\n"
sleep 1

printf "\n---- RUNNING COMMAND TO ENABLE MONITORING & BACKUP AGENTS AND DEPLOY REPLICA SET\n\n"
curl --user "${USERID}:${PUBLIC_API_KEY}" --digest --include --header "Content-Type: application/json" --request PUT "http://${OPSMGR_HOST}/api/public/v1.0/groups/${PROJECTID}/automationConfig" --data '
{
    "backupVersions": [
        {
            "hostname": "myserver1"
        }
    ],
    "monitoringVersions": [
        {
            "hostname": "myserver2"
        }
    ],
    "processes": [
        {
            "args2_6": {
                "net": {
                    "port": 27017
                },
                "replication": {
                    "replSetName": "TestRS"
                },
                "storage": {
                    "dbPath": "/data",
                    "wiredTiger" : {
                        "collectionConfig" : { },
                        "engineConfig" : {
                            "cacheSizeGB" : 0.25
                        },
                        "indexConfig" : { }
                    }
                },
                "systemLog": {
                    "path": "/data/mongodb.log"
                }
            },
            "hostname": "myserver1",
            "logRotate": {
                "sizeThresholdMB": 1000.0,
                "timeThresholdHrs": 24
            },
            "name": "myserver1",
            "processType": "mongod",
            "version": "4.2.1-ent",
            "authSchemaVersion": 5,
            "featureCompatibilityVersion" : "4.2"
        },
        {
            "args2_6": {
                "net": {
                    "port": 27017
                },
                "replication": {
                    "replSetName": "TestRS"
                },
                "storage": {
                    "dbPath": "/data",
                    "wiredTiger" : {
                        "collectionConfig" : { },
                        "engineConfig" : {
                            "cacheSizeGB" : 0.25
                        },
                        "indexConfig" : { }
                    }
                },
                "systemLog": {
                    "path": "/data/mongodb.log"
                }
            },
            "hostname": "myserver2",
            "logRotate": {
                "sizeThresholdMB": 1000.0,
                "timeThresholdHrs": 24
            },
            "name": "myserver2",
            "processType": "mongod",
            "version": "4.2.1-ent",
            "authSchemaVersion": 5,
            "featureCompatibilityVersion" : "4.2"  
        },
        {
            "args2_6": {
                "net": {
                    "port": 27017
                },
                "replication": {
                    "replSetName": "TestRS"
                },
                "storage": {
                    "dbPath": "/data",
                    "wiredTiger" : {
                        "collectionConfig" : { },
                        "engineConfig" : {
                            "cacheSizeGB" : 0.25
                        },
                        "indexConfig" : { }
                    }
                },
                "systemLog": {
                    "path": "/data/mongodb.log"
                }
            },
            "hostname": "myserver3",
            "logRotate": {
                "sizeThresholdMB": 1000.0,
                "timeThresholdHrs": 24
            },
            "name": "myserver3",
            "processType": "mongod",
            "version": "4.2.1-ent",
            "authSchemaVersion": 5,
            "featureCompatibilityVersion" : "4.2"
        }
    ],
    "replicaSets": [
        {
            "_id": "TestRS",
            "protocolVersion": 1,
            "members": [
                {
                    "_id": 0,
                    "host": "myserver1"
                },
                {
                    "_id": 1,
                    "host": "myserver2"
                },
                {
                    "_id": 2,
                    "host": "myserver3"
                }
            ]
        }
    ]
}
'
printf "\n\n\n"
sleep 1

printf "\n----LOOPING INDEFINILTY (SLEEPING FOR 5 SECONDS EACH TIME) TO SHOW THE DEPLOYMENT STATUS - PRESS CTRL-C TO TERMINATE\n\n"
while(true); do
    printf "\n\n"
    curl --user "${USERID}:${PUBLIC_API_KEY}" --digest --include --header "Accept: application/json" --request GET "http://${OPSMGR_HOST}/api/public/v1.0/groups/${PROJECTID}/automationStatus?pretty=true"
    sleep 5
done

echo

