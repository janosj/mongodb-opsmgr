echo "Run this from your laptop to pull down the Ops Manager CA file."
echo "Your web browser needs this to access the Ops Manager UI."
echo "The agents also need it to connect to Ops Manager."
echo

echo "Your AWS key is required to access the Ops Manager instance."
echo "This script is wired to look for it in the $HOME/Keys/ directory."
read -p "Enter the name of your AWS keyfile (no extension): " KEYFILE

# opsmgr-aws has to be an entry in your local hosts file.
echo "Downloading Ops-Manager cert from opsmgr-aws to local Downloads folder..."
scp -i $HOME/Keys/$KEYFILE.pem ec2-user@opsmgr-aws:./opsmgrCA.pem ~/Downloads/

echo "Server cert successfully downloaded (~/Downloads/opsmgrCA.pem)."
echo "Import it via Keychain Access. Launch the Mac utility, "
echo "select the Default login Keychain on the left, "
echo "then the Certificates tab on the top-right, "
echo "and drag and drop the downloaded opsmgrCA.pem file into this space."
echo "Then, double-click on it and switch Trust to 'Always Trust'"
echo "If this is done correctly, you can access the Ops Manager UI"
echo "without out seeing any privacy warnings." 


