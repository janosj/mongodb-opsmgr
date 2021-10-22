source ../conf/demo.conf

if [ -z "$MDB_CONNECT" ]
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

# 200k documents ~ 272MB
mgeneratejs CustomerSingleView.json -n 150000 | mongoimport --uri $MDB_CONNECT  --collection customers
