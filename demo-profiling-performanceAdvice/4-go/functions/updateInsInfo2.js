for (i=1; i<=10000; i++) {
   start = new Date().getTime();
   db.customers.update({
      'firstname': 'Martin', 
      'lastname': 'Ramirez'
   },
   { $set: { "policies.$[elem].risk" : 300 } },
   {
      multi: true,
      arrayFilters: [ { "elem.policyType": "life" } ]
   });
   print("Update operation ", i, ". time (ms): ", ((new Date().getTime())-start));
}
