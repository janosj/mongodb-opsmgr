// Test file, for verifying the updateLocalHostsFile function is working.

var hostFileUtil = require("./updateLocalHostsFile");

var hostname = "agent8";
var publicIpAddress = "pub.ip.addr.x";
var privateDnsName = "ip-172-31-52-7.ec2.internal";

hostFileUtil.updateLocalHostsFile(hostname, publicIpAddress, privateDnsName);

