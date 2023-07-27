// Reads in an entire file, replaces any lines with a match, writes new output file. 
// Runs synchronously. 
exports.updateLocalHostsFile = function (hostname, publicIpAddress, privateDnsName) {

  const os = require('os');
  const homeDir = os.homedir();

  const fs = require('fs');
  var replaceSearchToken = "AUTOREPLACE-" + hostname.toUpperCase();
  var hostsEntryLine = publicIpAddress + "\t" + hostname + "\t" + privateDnsName + "\t# " + replaceSearchToken;
  var myRegEx = new RegExp("^.*" + replaceSearchToken + ".*", "gm");
  var knownhostsRegEx = new RegExp("^.*" + hostname + ".*", "gm");

  try {

    const originalFile = fs.readFileSync('/etc/hosts', 'utf8');
    var newFile = originalFile.replace(myRegEx, hostsEntryLine);

    // No changes to file, so original file didn't have a matching entry.
    // Add it to the end.
    if (newFile == originalFile) {
      newFile += "# ######################\n";
      newFile += "# No matching entry to replace, so added to the end, sorry for the mess.\n"
      newFile += hostsEntryLine + "\n";
      newFile += "# ######################\n";
    }

    //console.log(newFile);
    fs.writeFileSync('/etc/hosts', newFile, 'utf8');
    console.log("Local /etc/hosts file has been updated.");

    const knownHostsFileName = homeDir + '/.ssh/known_hosts';
    const knownHostsFile = fs.readFileSync(knownHostsFileName, 'utf8');
    fs.writeFileSync(knownHostsFileName, knownHostsFile.replace(knownhostsRegEx, ''), 'utf8');
    console.log("Local " + knownHostsFileName + " file has been updated.");

  } catch(err) {
    console.error(err);
    //return console.log(err);
  }
     
}

/* 
// For testing:
var hostname = "agent8";
var publicIpAddress = "pub.ip.addr.x";
var privateDnsName = "ip-172-31-52-7.ec2.internal";
updateKnownHostsFile(hostname, publicIpAddress, privateDnsName);
*/
