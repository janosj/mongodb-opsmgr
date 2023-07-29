# Demo: Database Monitoring and Performance Advisor

This small demo can be used to demonstrate Ops Manager's monitoring and performance advisor capabilities. Two clients are provided - one that runs slow queries on large amounts of data, and a second that updates a single record. Running these clients will generate interesting visuals for the Real Time Performance Panel, Monitoring Status, and Profiler, as well as drive recommendations from the Performance Advisor. If the recommendation is taken to create an index on the Customers collection, viewers will see dramatically improved performance (when viewing the output of *runUpdate.sh*).  

## Prerequisites

- *loadAtlasDatasets.sh* uses **mongorestore**. This script is unnecessary when using Atlas, as those sample datasets can be loaded directly using the Atlas user interface. 

- *genIndexDemoData.sh* uses **node.js** and the **mgenerate** module (try "npm install -g mgeneratejs").

- *runSlowQueries.sh* and *runUpdate.sh* both use **mongosh**.

