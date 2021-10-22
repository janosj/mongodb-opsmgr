# Profiling was redone in Ops Manager 4.4
# These steps are no longer required.

source ../conf/demo.conf

if [ -z "$MDB_CONNECT" ] 
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

mongo $MDB_CONNECT --eval '
  db.getSiblingDB("sample_airbnb").setProfilingLevel(0);
  db.getSiblingDB("sample_airbnb").setProfilingLevel(1,{slowms:100});
  db.getSiblingDB("sample_mflix").setProfilingLevel(0);
  db.getSiblingDB("sample_mflix").setProfilingLevel(1,{slowms:100});
  db.getSiblingDB("sample_training").setProfilingLevel(0);
  db.getSiblingDB("sample_training").setProfilingLevel(1,{slowms:100});
  db.getSiblingDB("sample_weatherdata").setProfilingLevel(0);
  db.getSiblingDB("sample_weatherdata").setProfilingLevel(1,{slowms:100});
  db.getSiblingDB("test").setProfilingLevel(0);
  db.getSiblingDB("test").setProfilingLevel(1,{slowms:100});
'
