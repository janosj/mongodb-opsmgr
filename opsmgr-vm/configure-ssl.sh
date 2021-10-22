# Steps to configure SSL connections to Ops Manager web app.
# Docs: https://docs.opsmanager.mongodb.com/current/tutorial/configure-ssl-connection-to-web-interface/

# Process Overview:
# Create a self-signed cert
# Configure Ops Manager and restart
# Open VM Port (8443). New URL will be https://opsmgr:8443.
# Get browsers to recognize the self-signed cert.
# Modify agents to use HTTPS.

# Create self-signed cert
# Note: subjectAltName (SAN) is required by Chrome
# If this generates an error (can't load /home/opsmgr/.rnd into RNG),
# the fix is to comment RANDFILE line in /etc/ssl/openssl.cnf
openssl req -newkey rsa:2048 -nodes -keyout opsmgrCA.key -x509 -subj "/CN=opsmgr" -addext "subjectAltName = DNS:opsmgr" -days 3650 -extensions v3_ca -out opsmgrCA.crt

cat opsmgrCA.crt opsmgrCA.key > opsmgrCA.pem
sudo chown mongodb-mms:mongodb-mms opsmgrCA.pem
sudo chmod 600 opsmgrCA.pem
sudo cp -p opsmgrCA.pem /etc/mongodb-mms

# The CA file has to be copied into the agent containers
# so they can connect to Ops Manager over SSL.
sudo cp -p opsmgrCA.pem agents-dockerfile

echo "Next steps:"
echo " - Go into the Ops Manager config pages and set the URL and PEM Key File"
echo " - Restart Ops Manager"
echo " - Ensure port 8443 is open"
echo " - Take steps for browser to recognize self-signed cert"
echo " - Modify agents to connect over SSL"

