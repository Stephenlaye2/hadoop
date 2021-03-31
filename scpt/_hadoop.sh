#!/bin/bash


echo "HADOOP INSTALLATION"

cd ~/opt


# Remove any the download if exists
sudo rm -f hadoop-2.7.3.tar.gz

# Download from the following url
echo "Downloading from URL..."
wget http://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz

# Unzip the downloaded file
echo "Unzipping file..."
tar -zxf hadoop-2.7.3.tar.gz

# Remove the downloaded file
sudo rm hadoop-2.7.3.tar.gz

# Assign all admin rights to folders/files
cd
sudo chmod 777 -R opt/

cd hadoop-2.7.3
sudo mkdir hdfs
cd hdfs
sudo mkdir datanode
sudo mkdir namenode
cd


# Edit the .bash_profile file
echo "Adding settings to .bash_profile file"

echo '
## HADOOP_HOME
export HADOOP_HOME=~/opt/hadoop-2.7.3
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin'  >> .bash_profile

source .bash_profile

# cd into opt/hadoop-2.7.3/etc/hadoop
cd opt/hadoop-2.7.3/etc/hadoop

echo "Adding all configurations..."

# Inject setting to hadoop-env.sh file
ex="export JAVA_HOME=~/opt/jdk1.8.0_221"
sudo sed -i "25s@.*@${ex}@" hadoop-env.sh

# Remove empty configuration tags in the core-site.xml file
sudo sed -i "s@<configuration>@ @g" core-site.xml
sudo sed -i "s@</configuration>@ @g" core-site.xml

# Add config settings to core-site.xml file
echo '
<configuration>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://localhost:9000</value>
  </property>
</configuration>' >> core-site.xml


# Remove empty configuration tags in the hdfs-site.xml file
sudo sed -i "s@<configuration>@ @g" hdfs-site.xml
sudo sed -i "s@</configuration>@ @g" hdfs-site.xml

# Add config settings to hdfs-site.xml file
echo '
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>

  <property>
    <name>dfs.name.dir</name>
    <value>file://~/opt/hadoop-2.7.3/hdfs/namenode</value>
  </property>

  <property>
    <name>dfs.name.dir</name>
    <value>file://~/opt/hadoop-2.7.3/hdfs/datanode</value>
  </property>
</configuration>' >> hdfs-site.xml


# Remove empty configuration tags in the yarn-site.xml file
sudo sed -i "s@<configuration>@ @g" yarn-site.xml
sudo sed -i "s@</configuration>@ @g" yarn-site.xml

# Add config settings to yarn-site.xml
echo '
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>' >> yarn-site.xml


# Make a copy of mapred-site.xml.template file:
sudo cp mapred-site.xml.template mapred-site.xml

# Remove empty configuration tags in the mapred-site.xml file
sed -i "s@<configuration>@ @g" mapred-site.xml
sed -i "s@</configuration>@ @g" mapred-site.xml

# Add config settings to the mapred-site.xml file
echo '
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>' >> mapred-site.xml

# Install SSH
sudo apt-get install openssh-server

# Create/Gendrate the SSH Key
sudo ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
sudo chmod -R 750 ~/.ssh/authorized_keys

# Format hdfs namenode
hdfs namenode -format

# Source the .bash_profile
source ~/.bash_profile

echo '
Hadoop Installation Successful !!!'
