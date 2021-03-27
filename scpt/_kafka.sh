#!/bin/bash

#!/bin/bash

echo "KAFKA INSTALLATION"

cd ~/opt


# Remove any the download if exists
sudo rm -f kafka_2*

# Download from the following url
echo "Downloading from URL..."
sudo wget http://archive.apache.org/dist/kafka/2.3.1/kafka_2.11-2.3.1.tgz

# Unzip the downloaded file
echo "Unzipping file..."
tar -zxf kafka_2.11-2.3.1.tgz

# Remove the downloaded file
sudo rm kafka_2.11-2.3.1.tgz

# Rename app folder
sudo mv kafka_2.11-2.3.1.tgz/ kafka_2.3.1

# Assign all admin rights to folders/files
cd
sudo chmod 777 -R opt/

# Edit the .bash_profile file
echo 'Adding settings to .bash_profile file'

echo '
#KAFKA_HOME
export KAFKA_HOME=~/opt/kafka_2.3.1
export PATH=$PATH:$KAFKA_HOME/bin

' >> ~/.bash_profile

source .bash_profile

echo '
KAFKA Installation Successful !!!
'
