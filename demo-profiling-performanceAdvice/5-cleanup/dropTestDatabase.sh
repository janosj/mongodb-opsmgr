source ../conf/demo.conf

if [ -z "$MDB_CONNECT" ]
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

mongo "$MDB_CONNECT" --eval "
 db.getSiblingDB('test').dropDatabase();
"

