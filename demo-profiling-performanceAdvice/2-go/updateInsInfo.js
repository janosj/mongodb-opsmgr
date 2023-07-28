for (i=1; i<=10000; i++) {
   start = new Date().getTime();
   db.customers.update({
      'region': i, 
      'address.state': 'UT', 
      'policies': {$elemMatch: {'policyType': 'life', 'insured_person.smoking': true}},
      'yob': {$gte: ISODate('1990-01-01'), $lte : ISODate('1990-12-12')},
      'gender': 'Female' 
   },
   { $set: { "policies.$[elem].risk" : 300 } },
   {
      multi: true,
      arrayFilters: [ { "elem.policyType": "life" } ]
   });
   print("Update operation", i, ". time (ms): ", ((new Date().getTime())-start));
}
