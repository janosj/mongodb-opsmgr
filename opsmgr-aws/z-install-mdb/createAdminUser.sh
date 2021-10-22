mongo --eval 'db.getSiblingDB("admin").createUser( { user:"admin", pwd: passwordPrompt(), roles: ["root"] } );'

