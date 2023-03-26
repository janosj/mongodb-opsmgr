echo "Run this from your laptop to pull down the Ops Manager CA file."
echo "Your web browser needs this to access the Ops Manager UI."
echo "The agents also need it to connect."
echo

echo "Your AWS key is required to access the Ops Manager instance."
read -p "Name of your AWS keyfile (no extension): " KEYFILE

# opsmgr-aws has to be an entry in your local hosts file.
echo "Pulling cert from opsmgr-aws..."
scp -i $HOME/Keys/$KEYFILE.pem ec2-user@opsmgr-aws:./opsmgrCA.pem ~/Downloads/

echo "Server cert successfully downloaded (~/Downloads/opsmgrCA.pem)."
echo "Import it via Keychain Access (Mac utility, drag and drop into login section)"
echo "Double-click on it, switch Trust to 'Always Trust'"


