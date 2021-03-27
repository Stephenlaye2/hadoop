#!/bin/bash


echo "Java + Hadoop + Spark + Kafka Installation"
#sudo apt update

# Check for update
echo "Running update..."
sudo apt update

echo "Installing Java..."
bash ./scpt/_java.sh

echo "Installing Hadoop..."
bash ./scpt/_hadoop.sh

echo "Installing Kafka..."
bash ./scpt/_kafka.sh

echo "Installing Spark..."
bash ./scpt/_spark.sh

cd

# Source .bach_profile in .bachrc
echo 'source .bash_profile' >> .bashrc

