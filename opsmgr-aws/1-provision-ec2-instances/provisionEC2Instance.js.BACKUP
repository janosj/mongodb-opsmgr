// ***********************
// Provisions an EC2 instance for Ops Manager.
// Updates hosts file with connect info.
// ***********************

const tagExpireOn = new Date().getFullYear() + "-12-31";  // Dec 31 of current year.
// console.log(new Date().getFullYear() + "-12-31");

// Pull args from the command line.
function usage() {
  console.log('Usage: provisionEC2Instance keyName securityGroupID subnetID tagName tagOwner rootVolumeGB instanceType imageId etcHostname');
  console.log('  keyName: name of AWS key');
  console.log('  securityGroupID: name of AWS security group to attach to instance');
  console.log('  subnetID: AWS subnetID for the instance');
  console.log('  tagName: value for the AWS tag Name');
  console.log('  tagOwner: value for the AWS tag Owner');
  console.log('  rootVolumeGB: size of the root volume in GB');
  console.log('  instanceType: AWS instance type');
  console.log('  imageId: Name of AWS OS image');
  console.log('  etcHostname: name of host as it appears in /etc/hosts');
}

try {

  var myArgs = process.argv.slice(2);
  var keyName = myArgs[0];
  var secGroupID = myArgs[1];
  var subnetID = myArgs[2];
  var tagName = myArgs[3];
  var tagOwner = myArgs[4];
  var rootVolumeGB = myArgs[5];
  var instanceType = myArgs[6];
  var imageId = myArgs[7];
  var etcHostname = myArgs[8];

  console.log("Provisioning EC2 instance with following settings:");
  console.log("  AWS keyName: " + keyName );
  console.log("  AWS Security Group ID: " + secGroupID);
  console.log("  AWS subnet ID: " + subnetID);
  console.log("  tag (Name): " + tagName);
  console.log("  tag (Owner): " + tagOwner);
  console.log("  tag (Expire-On): " + tagExpireOn);
  console.log("  root Volume Size: " + rootVolumeGB);
  console.log("  Instance Type: " + instanceType);
  console.log("  imageID: " + imageId);
  console.log("  etcHostname: " + etcHostname);

} catch (e) {
  usage();
  process.exit(1);
}

// from here: https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/ec2-example-creating-an-instance.html

// Requires: 
// npm install -g aws-sdk
// export NODE_PATH=/usr/local/lib/node_modules

// AWS credentials have to be set, now via SSO.
// SSO credentials have to be exported until the SDK becomes SSO aware.
// Use awsLogin.sh, which calls setEnvAWS.py

// Load the AWS SDK for Node.js
// The profile name must be set prior to loading (defaults to 'default').
// e.g. process.env.AWS_PROFILE = "poweruser";
process.env.AWS_SDK_LOAD_CONFIG = true;
var AWS = require('aws-sdk');

// Set the region explicitly. 
// Unnecessary because AWS_SDK_LOAD_CONFIG is set to true up above.
// e.g. AWS.config.update({region:'us-east-1'});

//console.log("Access key:", AWS.config.credentials.accessKeyId);
//console.log("Region: ", AWS.config.region);
//console.log("secret: ", AWS.config.credentials);

// from here: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/EC2.html#runInstances-property

 var params = {
  BlockDeviceMappings: [
     {
    DeviceName: "/dev/sda1", 
    Ebs: {
     VolumeSize: rootVolumeGB
    }
   }
  ], 
  ImageId: imageId, 
  InstanceType: instanceType,
  KeyName: `${keyName}`, 
  MaxCount: 1, 
  MinCount: 1, 
  SecurityGroupIds: [
     `${secGroupID}`
  ], 
  SubnetId: `${subnetID}`, 
  TagSpecifications: [
    {
      ResourceType: "instance", 
      Tags: [
        { Key: "Name", Value: `${tagName}` },
        { Key: "owner", Value: `${tagOwner}` },
        { Key: "expire-on", Value: tagExpireOn },
        { Key: "purpose", Value: "opportunity" }  // Valid: opportunity, training, partner, other.
      ]
    }
  ]
 };

console.log("***Provisioning EC2 instance...");

// Create a promise on an EC2 service object
var instancePromise = new AWS.EC2({apiVersion: '2016-11-15'}).runInstances(params).promise();

// Handle promise's fulfilled/rejected states
instancePromise.then(

  function(data) {

    console.log(data);
    var instanceId = data.Instances[0].InstanceId;

    console.log("Created instance", instanceId);

    var privateDnsName = data.Instances[0].PrivateDnsName;
    var privateIpAddress = data.Instances[0].PrivateIpAddress;
    console.log("Private DNS Name:", privateDnsName);
    console.log("Private IP Address:", privateIpAddress);

    console.log("Retrieving Public IP/DNS info for instanceID:", instanceId);

    var params = {
      InstanceIds: [
        instanceId
     ]};
    
     // On using Promises: https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/using-promises.html
     // On race conditions: https://github.com/aws/aws-sdk-ruby/issues/193
     // On waitFor InstanceExists:  https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/EC2.html#instanceExists-waiter

    var ec2 = new AWS.EC2({apiVersion: '2016-11-15'});

    // The public IP address and DNS doesn't exist yet, so we have to wait for it.
    // But we can't even describe the instance until we wait for instanceExists.
    console.log("Waiting for instance...");
    ec2.waitFor('instanceExists', params, function(err, data) {
      if (err) console.log(err, err.stack); // an error occurred
      else {

        console.log("SUCCESS: Instance Exists.");           // successful response

        var publicIp = "";
        var publicDnsName = "";

        var myInt = setInterval(function () {

          console.log("Retrieving instance details...");
          ec2.describeInstances(params, function(err, data) {
            if (err) {
              console.log("Error", err.stack);
            } else {
              console.log("SUCCESS: describeInstances returned.");
              try {
                publicIpAddress = data.Reservations[0].Instances[0].PublicIpAddress;
                publicDnsName = data.Reservations[0].Instances[0].PublicDnsName;
                console.log("Public DNS Name:", publicDnsName);
                console.log("Public IP Address:", publicIpAddress);
                if (publicDnsName != "" && publicIpAddress != "") {

                  // We've got the info, so stop checking for it.
                  clearTimeout(myInt);

                  // Update /etc/hosts with the connect info.
                  var hostFileUtil = require("./updateLocalHostsFile");
                  hostFileUtil.updateLocalHostsFile(etcHostname, publicIpAddress, privateDnsName);
                  
                } else {
                  console.log(" Still no public IP address or DNS name. Will try again in 5 seconds.");
                }

              } catch (e) {
                console.log(" Still no public IP address or DNS name. Will try again in 5 seconds.");
              };
            }
          });

        }, 5000);

      } 
    });


  }).catch(
    function(err) {
    console.error(err, err.stack);
  });
