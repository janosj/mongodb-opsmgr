# This requires AWS CLI.
# See here for installation instructions:
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# Try "Command line installer - All users"

aws sso login

echo "Exporting credentials..."
setEnvAWS.py
echo "done."

