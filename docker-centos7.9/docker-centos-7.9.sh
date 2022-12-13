echo 'Installing Please Wait'
echo "=================================================="
echo 'Setup Installer'
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# TODO: Can't install NPM latest version
sudo curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash -

echo  'Installing Git'
sudo yum install git -y

# TODO: Can't install NPM latest version
echo 'Install NPM'
echo "=================================================="
sudo yum install libstdc++.so.6 -y 
sudo yum install libm.so.6 -y
sudo yum install nodejs -y


echo 'Installing Docker'
echo "=================================================="
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
