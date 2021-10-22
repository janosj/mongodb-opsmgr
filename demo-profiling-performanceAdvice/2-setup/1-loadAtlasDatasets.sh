source ../conf/demo.conf

if [ -z "$MDB_CONNECT" ]
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

# Download the Atlas sample data sets.
# Instructions here:
# https://developer.mongodb.com/article/atlas-sample-datasets/#downloading-the-dataset-for-use-on-your-local-machine
ATLAS_DATASET_FILE=$HOME/downloads/atlas-sample-datasets.archive
if [ ! -f "$ATLAS_DATASET_FILE" ]; then

  echo "Atlas sample datasets file not found locally. Downloading... "

  if [ ! -d "$HOME/downloads/" ]; then
    mkdir $HOME/downloads
  fi

  curl https://atlas-education.s3.amazonaws.com/sampledata.archive -o $ATLAS_DATASET_FILE
  echo "Finished downloading."

fi

echo "Importing data to MongoDB at $MDB_CONNECT ..."
mongorestore --uri="$MDB_CONNECT" --nsInclude=sample_airbnb.listingsAndReviews --nsInclude=sample_training.grades --nsInclude=sample_mflix.movies --nsInclude=sample_weatherdata.data --archive=$ATLAS_DATASET_FILE
echo "Done."

