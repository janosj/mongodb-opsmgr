// Node.js code to deploy a cluster using the Ops Manager API.
// Ops Manager must be deployed in advance. This script does not support SSL.

// Use "npm install" to install Node.js dependencies.

// To run: node deployShardedCluster.js

// File containing the desired cluster configuration.
// The easiest way to figure this out is to deploy what you want with Ops Manager,
// then retrieve the automationConfig.json file and see what it looks like. 
// The full file is huge - add only the relevant sections to clusterConfig.
const CONFIG_FILE="clusterConfig.json"

// This script does not support SSL.
const OPSMGR_HOST="localhost:8080"

// From Ops Manager, the Project ID (see Project Settings).
const PROJECT_ID="64d564cd84b88e42d82b3233"

// From Ops Manager, the API Key created in the project,
// with Project Owner permissions and a suitable API access list. 
const OM_USER="uivnciin"
const PUBLIC_API_KEY="8c78814a-314a-4f5e-8bf8-3d82ad19c0d2"


// All MongoDB processes belong to a single Automation Config. To make changes,
// retrieve the current config, make changes, and replace the entire configuration using PUT.
// Since this requires some JSON manipulation, we'll use node.js rather than bash scripting.

// Docs: Deploy a Cluster through the API
// https://www.mongodb.com/docs/ops-manager/current/tutorial/create-cluster-with-api/
// That uses curl, so we have to look elsewhere for node.js guidance.


console.log("Retrieving desired cluster config from file....");

// npm install fs
const fs = require('fs');
const newConfig = JSON.parse(fs.readFileSync(CONFIG_FILE, 'utf8'));


console.log("Retrieving existing configuration from Ops Manager....");

// The Ops Manager Public API (Atlas, too) requires Digest Authentication, 
// to ensure that your Public API Key is never sent over the network. 
// Basic authentication cannot be used.
// See here: https://www.mongodb.com/docs/ops-manager/current/core/api/

// Libraries that don't support digest authentication can't be used (easily). Sorry, Axios.
// npm install axios

// urllib suggestion comes from node.js code example from here:
// https://www.mongodb.com/developer/products/atlas/nodejs-python-ruby-atlas-api/
// Also helpful, see urllib usage here:
// https://www.npmjs.com/package/urllib

// npm install urllib
const urllib = require('urllib');
const apiUrl = `http://${OPSMGR_HOST}/api/public/v1.0/groups/${PROJECT_ID}/automationConfig?pretty=true`;
var   options = { 
  digestAuth: `${OM_USER}:${PUBLIC_API_KEY}`,
}

// Default method with urllib is GET, so this will pull the existing config.
urllib.request( apiUrl, options ).then( ({data, res}) => {

    console.log("Received response from server.");
    const code = res.statusCode;
    if (code != 200) {
      console.log("Encountered an error!");
      console.log(JSON.parse(data));
      console.log();
    } else {

      // Pull was successful. Now push the new config.

      var config = JSON.parse(data);
      config.processes = newConfig.processes;
      config.replicaSets = newConfig.replicaSets;
      config.sharding = newConfig.sharding;
      //console.log(config);

      // To submit mods, use different options with the same URL.
      options.method = "PUT";
      options.data = config;
      options.contentType = "json";

      console.log("Pushing new cluster config to Ops Manager....");

      urllib.request( apiUrl, options ).then( ({data, res}) => {

        console.log("Received response from server.");
        const code = res.statusCode;
        if (code != 200) {
          console.log("Encountered an error!");
          console.log(JSON.parse(data));
          console.log();
        } else {
          console.log("Update successful!");
          console.log(JSON.parse(data));
          console.log();
        }

      });

    }

});

