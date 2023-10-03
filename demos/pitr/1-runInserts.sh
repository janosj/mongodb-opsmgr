#!/bin/bash
# Runs a simple node client that inserts a document every second.

source demo.conf

URI="$MDB_URI" node client-insertRecords.js

