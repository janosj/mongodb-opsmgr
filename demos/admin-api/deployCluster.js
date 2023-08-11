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
const PROJECT_ID="64d6669bfffbfe424a600c81"

// Create an API key in Ops Manager and enter it here.
// Access Manager > Project Access > API Keys > Create API Key
// Project Permissions: Project Owner (the rest can be cleared).
// Also add an Access List Entry. You can Use Current IP Address
// and switch it to XXX.0.0.0/8.
const OM_PUBLIC_KEY="mbfrwmve"
const OM_PRIVATE_KEY="2642b692-1c64-40fb-a0f5-3341ef97b754"


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
  digestAuth: `${OM_PUBLIC_KEY}:${OM_PRIVATE_KEY}`,
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

