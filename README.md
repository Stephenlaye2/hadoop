****

### Java, Hadoop, Kafka, Spark Installation Instructions
---

### 1. Oracle Virtualbox (optional)
1. Visit the link below and choose your right OS version to download:
[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

2. Install. Follow the instructions based on your OS. If you are using Ubuntu, I recommend you download and install from the Ubuntu Software Center.

3. Download the Ubuntu OS version 18.
  [Click here to download](http://old-releases.ubuntu.com/releases/18.04.4/ubuntu-18.04-desktop-amd64.iso)
4. Create a new VM in your Oracle Virtualbox and install the Ubuntu 18. Follow the instructions.
5. (Optional) After the installation, clone the newly install VM.

### 2. Install Java, Hadoop, Kafka, Spark
1. Update your packages
   <pre><code>sudo apt-get update</code>
2. Install Git
   <pre><code>sudo apt-get install git -y</code>
3. Let's clone a repository on the desktop.
   <pre><code>cd ~/Desktop
   sudo git clone https://github.com/dseneh-eit/Hadoop</code></pre>
   
4. cd into the cloned repository and execute the bash command
   <pre><code>cd Hadoop/
   sudo bash hadoop_install.sh</code></pre>
   *Wait for the installation to complete. Sometimes it takes a little longer.*
5. Test you installation
   <pre><code>jps</code></pre>
   If you get <code>Jps</code> back, then congratulations!
   If not, source your .bash_profile and .bashrc files respectively:
   <pre><code>source ~/.bash_profile
   source ~/.bashrc</code></pre>

### 3. Install Hive
1. In your terminal, paste the below code:
   <pre><code>cd ~/opt
   sudo wget http://archive.apache.org/dist/hive/hive-2.3.5/apache-hive-2.3.5-bin.tar.gz</code></pre>
2. Unzip the downloaded file and rename the folder:
   <pre><code>tar -xvf apache-hive-2.3.5-bin.tar.gz
   sudo mv apache-hive-2.3.5-bin.tar.gz hive</code></pre>
3. Let's open and edit the **.bash_profile** file:
   <pre><code>cd ~ 
   sudo gedit .bash_profile</code>
4.  In your **.bash_profile** file, paste the following:
    <pre><code>#HIVE_HOME
    export HIVE_HOME=/home/<USER>/hive
    export PATH=$PATH:$HIVE_HOME/bin</code></pre>
5.  Give it a quick test with:
    <pre><code>hive --version</code></pre>
    *You should get the version of hive back*
6.  Next, we need to create some directories in HDFS. But before that, let's start our hadoop cluster. If you have yours started already, skip this step:
    <pre><code>start-all.sh</code></pre>
    To verfiy if your cluster is running, run the following command:
    <pre><code>jps</code></pre>
    If all goes well, you should see the below (the order doesn't matter):
    <pre><i>NameNode
    DataNode
    ResourceManager
    Jps
    NodeManager
    SecondaryNameNode</i></pre>

    If you didn't get them all, then please check your configurations.
7.  Create directories and add permissions in HDFS:
    <pre><code>hadoop fs -mkdir -p /user/hive/warehouse
    hadoop fs -chmod g+w /user/hive/warehouse</code></pre>
8. cd into hive config folder and create/edit `hive-env.sh`:
   <pre><code>cd ~/opt/hive/conf
   sudo gedit hive-env.sh
   </code></pre>
   Paste the below in the hive-env.sh file and save:
   <pre><code>export HADOOP_HOME=/home/<USER>/hadoop
   export HADOOP_HEAPSIZE=512
   export HIVE_CONF_DIR=/home/<USER>/hive/conf</code>
9.  While still in `~/hive/conf`, create/edit `hive-site.xml`:
    <pre><code>sudo gedit hive-site.xml</code></pre>

    Paste the below and save:
    ```xml
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
        <property>
            <name>javax.jdo.option.ConnectionURL</name>
            <value>jdbc:derby:;databaseName=~/opt/hive/metastore_db;create=true</value>
            <description>JDBC connect string for a JDBC metastore.</description>
        </property>	
        <property>
            <name>hive.metastore.warehouse.dir</name>
            <value>/user/hive/warehouse</value>
            <description>location of default database for the warehouse</description>
        </property>
        <property>
            <name>hive.metastore.uris</name>
            <value>thrift://localhost:9083</value>
            <description>Thrift URI for the remote metastore.</description>
        </property>
        <property>
            <name>javax.jdo.option.ConnectionDriverName</name>
            <value>org.apache.derby.jdbc.EmbeddedDriver</value>
            <description>Driver class name for a JDBC metastore</description>
        </property>
        <property>
            <name>javax.jdo.PersistenceManagerFactoryClass</name>
            <value>org.datanucleus.api.jdo.JDOPersistenceManagerFactory</value>
            <description>class implementing the jdo persistence</description>
        </property>
        <property>
            <name>hive.server2.enable.doAs</name>
            <value>false</value>
        </property>
    </configuration>
    ```
10. (optional) Since Hive and Kafka are running on the same system, you'll get a warning message about some SLF4J logging file. From your Hive home you can just rename the file:
    <pre><code>cd ~/opt/hive
    sudo mv lib/log4j-slf4j-impl-2.6.2.jar lib/log4j-slf4j-impl-2.6.2.jar.bak</code></pre>
11.  Now we need to create a database schema for Hive to work with using **schematool**:
        <pre><code>schematool -initSchema -dbType derby</code></pre> 
        
12. We are now ready to enter the Hive shell and create the database for holding tweets. First, we need to start the Hive Metastore server with the following command:
        <pre><code>hive –-services metastore</code></pre>
    *This should give some output that indicates that the metastore server is running. You'll need to keep this running, so open up a new terminal tab to continue with the next steps.*
13. Now, leave the hive service running and open a new tab, start the Hive shell with the `hive` command:
    <pre><code>hive</code>
14. If you were able to get to this point: **CONGRATULATIONS!**