echo "Creates a profile called default in the CLI configuration file."
echo "File location will be $HOME/.config/mongocli.toml"
echo
echo "Pre-requisites:"
echo "1) Ops Manager must be running and reachable. Consider /etc/hosts entry."
echo "2) There needs to be a default org. Fetch the ID from Ops Manager."
echo "3) An API Key must exist. Add 10.0.2.2/32 to the whitelist."
mongocli config --service ops-manager


