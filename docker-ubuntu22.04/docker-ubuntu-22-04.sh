echo 'Installing Please Wait'
echo "=================================================="
sudo apt-get update 

echo 'Setup Repository'
echo "=================================================="
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get update

echo "Install GIT"
echo "=================================================="
sudo apt-get install git -y 

echo 'Install Docker'
echo "=================================================="
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

echo 'Install Node'
echo "=================================================="
sudo apt-get install nodejs -y


echo 'Setup Docker'
echo "=================================================="
sudo usermod -aG docker ${USER}
su - ${USER}