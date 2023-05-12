# Initiates a 3-node replica set.
# Run once using mongosh on a single host.
# Adjust internal host names before running.

rs.initiate( {_id : "rsTest",members: [ { _id: 0, host: "ip-172-31-51-201.ec2.internal:27017" }, { _id: 1, host: "ip-172-31-49-57.ec2.internal:27017" }, { _id: 2, host: "ip-172-31-53-11.ec2.internal:27017" }]})

