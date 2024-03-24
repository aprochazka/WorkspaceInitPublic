#! /bin/sh

read -s -p "Enter passphrase: " passphrase
echo

encrypted_token="U2FsdGVkX18plHFm+JGz0DUoREGzdhHR/wFTrM1ZVFELXtMtChs2LUv7g44oXKuQ
Ryr/BlQRWaTM4H0+aV7mKQ=="

decrypted_token=$(echo "$encrypted_token" | openssl enc -aes-256-cbc -a -d -salt -pass pass:"$passphrase" -pbkdf2 -iter 10000)

echo "Token decrypted"
echo

echo "Downloading gh cli...."
echo

sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list \
&& sudo apt update \
&& sudo apt install gh -y

echo
echo "gh cli installed"
echo

echo "Creating temporary token file"
touch token
echo "$decrypted_token" > token

echo "Authenticating gh cli using token"
gh auth login --with-token < token

echo "Removing temporaty token file"
rm -rf token

echo "Clonning Init workspace repo"
gh repo clone aprochazka/WorkspaceInit ../WorkspaceInit

echo "Running Init Workspace Script.."
bash ../WorkspaceInit/initPrivate.sh

