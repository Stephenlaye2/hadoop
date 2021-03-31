#!/bin/bash

echo "
===============================

JAVA INSTALLATION
===============================
"

cd

# Create opt folder if it doesn't exists
mkdir -p opt
cd opt

# Remove if already exists to avoid issues
rm -f jdk-8u221-linux-x64.tar.gz

# Download Java
echo "Downloading from URL.."
wget -O jdk-8u221-linux-x64.tar.gz -c --content-disposition "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=239835_230deb18db3e4014bb8e3e8324f81b43"
echo "Download complete!"

# Unzip downloaded file
echo "Unzipping file..."
tar -zxf jdk-8u221-linux-x64.tar.gz

# Delete download file
sudo rm jdk-8u221-linux-x64.tar.gz

cd

# Set the path in the .bash_profile file
echo "Adding settings to bash file..."

echo '
## JAVA_HOME
JAVA_HOME=~/opt/jdk1.8.0_221
export PATH=$PATH:$JAVA_HOME/bin' > .bash_profile

source ~/.bash_profile

echo '

Java Installation Successful !!'


