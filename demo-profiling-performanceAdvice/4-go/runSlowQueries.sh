source ../conf/demo.conf

if [ -z "$MDB_CONNECT" ] 
then
  echo "Environment not set. No MDB_CONNECT info."
  exit 1
fi

mongo --retryWrites $MDB_CONNECT --eval '
while (true) {
  pickRandomQuery = Math.floor(Math.random() * 4);
  print("running slow query...");
  switch (pickRandomQuery) {
    case 0:
      // airbnb query
      db = db.getSiblingDB("sample_airbnb");
  
      queryTermList = ["home", "new", "charming", "cosy"];
      queryTerm = queryTermList[Math.floor(Math.random() * queryTermList.length)];
      query = { description: { $regex: `.*${queryTerm}.*`, $options: "i" }, };
      sort = {};
      sort[queryTerm] = 1;

      res = db.listingsAndReviews.find(query).sort(sort)
      print(`performed airbnb query: found ${res.itcount()} docs`);
      break;
    case 1:
      // grades query
      db = db.getSiblingDB("sample_training");
  
      queryTermList = ["exam", "quiz", "homework"];
      queryTerm = queryTermList[Math.floor(Math.random() * queryTermList.length)];
      query = { "scores.type": queryTerm };
      sort = { student_id: 1, class_id: 1 };
      
      res = db.grades.find(query).sort(sort)
      print(`performed grades query: found ${res.itcount()} docs`);
      break;
    case 2:
      // mflix query
      db = db.getSiblingDB("sample_mflix");
  
      queryFieldList = ["plot", "title", "fullplot"];
      queryTermList = ["hero", "drama", "disaster", "horror"];
      queryField = queryFieldList[Math.floor(Math.random() * queryFieldList.length)];
      queryTerm = queryTermList[Math.floor(Math.random() * queryTermList.length)];
      query = {};
      query[queryField] = { $regex: `.*${queryTerm}.*`, $options: "i" };
      sort = {};
      sort[queryTerm] = 1;
      
      res = db.movies.find(query).sort(sort)
      print(`performed mflix query: found ${res.itcount()} docs`);
      break;
    case 3:
      // weather data query
      db = db.getSiblingDB("sample_weatherdata");
  
      queryList = [{ type: "FM-13" }, { callLetters: { $ne: "SHIP" }}];
      sortByList = [{ callLetters: 1 }, { callLetters: 1, qualityControlProcess: 1 }, { callLetters: 1, qualityControlProcess: 1, elevation: -1 }];
      matchQuery = queryList[Math.floor(Math.random() * queryList.length)];
      sortBy = sortByList[Math.floor(Math.random() * sortByList.length)];
  
      pipeline = [
        { $match: matchQuery },
        { $sort: sortBy }
      ];
      
      res = db.data.aggregate(pipeline, { allowDiskUse: true })
      print(`performed weather data query: found ${res.itcount()} docs`);
      break;
  }
}
'
