source ../conf/demo.conf

if [ -z "$MDB_CONNECT" ]
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

mongo --retryWrites $MDB_CONNECT practiceInsInfo.js

