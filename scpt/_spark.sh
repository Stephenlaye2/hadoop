#!/bin/bash

echo "SPARK INSTALLATION"

cd ~/opt


# Remove any the download if exists
sudo rm -f spark-2.3.2-bin-hadoop2.7.tgz

# Download from the following url
echo "Downloading from URL..."
sudo wget http://archive.apache.org/dist/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz


# Unzip the downloaded file
echo "Unzipping file..."
tar -zxf spark-2.3.2-bin-hadoop2.7.tgz

# Remove the downloaded file
sudo rm spark-2.3.2-bin-hadoop2.7.tgz

# Rename app folder
sudo mv spark-2.3.2-bin-hadoop2.7/ spark-2.3.2

# Assign all admin rights to folders/files
cd
sudo chmod 777 -R opt/

# Edit the .bash_profile file
echo "Adding settings to .bash_profile file"

echo '
#SPARK_HOME
export SPARK_HOME=~/opt/spark-2.3.2
export PATH=$PATH:$SPARK_HOME/bin

#PYSPARK_HOME
export PYTHONPATH=$PYTHONPATH:/usr/lib/python
export PYSPARK_PYTHON=python3.6

' >> ~/.bash_profile

source ~/.bash_profile

echo '
SPARK Installation Successful !!!'
