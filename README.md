****

### Installation for:
[Java, Hadoop, Spark](#2-install-java-hadoop-kafka-spark)
[Hive](#3-install-hive)
[HBase](#4-install-hbase)
[MySQL](#5-install-mysql)
[Airflow](#5-install-airflow)
---

### 1. Oracle Virtualbox (optional)
1. Visit the link below and choose your right OS version to download:
[https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

2. Install. Follow the instructions based on your OS. If you are using Ubuntu, I recommend you download and install from the Ubuntu Software Center.

3. Download the Ubuntu OS version 18:
  [Click here to download](http://old-releases.ubuntu.com/releases/18.04.4/ubuntu-18.04-desktop-amd64.iso)
4. Create a new VM in your Oracle Virtualbox and install the Ubuntu 18. Follow the instructions.
5. (Optional) After the installation, clone the newly install VM (for backup in case something goes wrong).
---
### 2. Install Java, Hadoop, Kafka, Spark
1. Update your packages:
   <pre><code>sudo apt-get update</code>
2. Install Git:
   <pre><code>sudo apt-get install git -y</code>
3. Let's clone a repository on the desktop:
   <pre><code>cd ~/Desktop
   sudo git clone https://github.com/dseneh-eit/hadoop</code></pre>
   
4. cd into the cloned repository and execute the bash command
   <pre><code>cd Hadoop/
   sudo bash install.sh</code></pre>
   *Wait for the installation to complete. Sometimes it takes a little longer.*
5. Test you installation:
   <pre><code>jps</code></pre>
   If you get <code>Jps</code> back, then congratulations!
   If not, source your .bash_profile and .bashrc files respectively:
   <pre><code>source ~/.bash_profile
   source ~/.bashrc</code></pre>
---
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
    export HIVE_HOME=~/opt/hive
    export PATH=$PATH:$HIVE_HOME/bin</code></pre>
5. Source your `.bash_profile` file:
    <pre><code>source ~/.bash_profile</code></pre>
   
7.  Give it a quick test with:
    <pre><code>hive --version</code></pre>
    *You should get the version of hive back*
8.  Next, we need to create some directories in HDFS. But before that, let's start our hadoop cluster. If you have yours started already, skip this step:
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
    <br />
9.  Create directories and add permissions in HDFS:
    <pre><code>hadoop fs -mkdir -p /user/hive/warehouse
    hadoop fs -chmod g+w /user/hive/warehouse</code></pre>
10. cd into hive config folder and create/edit `hive-env.sh`:
    <pre><code>cd ~/opt/hive/conf
    sudo gedit hive-env.sh</code></pre>
11. In the `hive-env.sh` file, find, uncommet and replace the values of the follow variables and to look like:
    <pre><code>export HADOOP_HOME=~/opt/hadoop-2.7.3
    export HADOOP_HEAPSIZE=512
    export HIVE_CONF_DIR=~/opt/hive/conf</code></pre>
11. While still in `~/hive/conf`, create/edit `hive-site.xml`:
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
12. (optional) Since Hive and Kafka are running on the same system, you'll get a warning message about some SLF4J logging file. From your Hive home you can just rename the file:
    <pre><code>cd ~/opt/hive
    sudo mv lib/log4j-slf4j-impl-2.6.2.jar lib/log4j-slf4j-impl-2.6.2.jar.bak</code></pre>
13.  Now we need to create a database schema for Hive to work with using **schematool**:
        <pre><code>schematool -initSchema -dbType derby</code></pre> 
        
14. We are now ready to enter the Hive shell and create the database for holding tweets. First, we need to start the Hive Metastore server with the following command:
        <pre><code>hive –-services metastore</code></pre>
    *This should give some output that indicates that the metastore server is running. You'll need to keep this running, so open up a new terminal tab to continue with the next steps.*
15. Now, leave the hive service running and open a new tab, start the Hive shell with the `hive` command:
    <pre><code>hive</code>
16. If you are able to get to this point: **CONGRATULATIONS!**
---
### 4. Install MySQL
1. First, let's update our packages:
    <pre><code>sudo apt-get update</code></pre>
2. Next, install MySQL server:
    <pre><code>sudo apt-get install mysql-server</code></pre>
    Enter the password as root when it prompts to enter a password
3. Login to mysql and check the available default databases:
    <pre><code>sudo mysql -u root -p [YOUR PASSWORD] </code></pre>
    <pre><code>show databases;</code></pre>
4. (Optional) Set the root user's password to 'root':
    <pre><code>ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';</code></pre>
5. Install the MySQL connector:
    <pre><code>sudo apt-get install libmysql-java</code></pre>
---
### 4. Install HBase
1. Let's cd into our `opt` folder and download hbase:
    <pre><code> cd ~/opt
    sudo wget http://archive.apache.org/dist/hbase/1.1.4/hbase-1.1.4-bin.tar.gz</code></pre>
2. Unzip the `.tar.gz` file:
    <pre><code>tar -xvf hbase-1.1.4-bin.tar.gz</code></pre>
3. In your **.bash_profile** file, paste the following:
    <pre><code> #HBASE_HOME
    export HBASE_HOME=~/opt/hbase-1.1.4
    export PATH=$PATH:$HBASE_HOME/bin</code></pre>
4. Source your `.bash_profile` file:
    <pre><code>source ~/.bash_profile</code></pre>
   
5. cd into the hbase conf folder and edit the `hbase-env.sh` file:
    <pre><code> cd ~/opt/hbase-1.1.4/conf/
    sudo gedit hbase-env.sh</code></pre>
6. In the `hbase-env.sh` file, find the `export HBASE_REGIONSERVERS` variable and uncomment it, replace it's value to look like this:
    <pre><code> export JAVA_HOME=~/opt/jdk1.8.0_221</code></pre>
    Also find and uncommet the following, then save and colse the file:
    <pre><code> export HBASE_REGIONSERVERS=${HBASE_HOME}/conf/regionservers
    export HBASE_MANAGES_ZK=true</code></pre>
7. While still in the hbase conf directory, also open and edit the `hbase-site.xml` file:
    <pre><code>sudo gedit hbase-site.xml</code></pre>
8. Paste the below between the ```<configuration>``` tags:
   ```xml
    <property>
        <name>hbase.rootdir</name>
        <value>hdfs://localhost:9000/hbase</value>
    </property>
    <property>
        <name>hbase.cluster.distributed</name>
        <value>true</value>
    </property>
    <property>
        <name>hbase.zookeeper.quorum</name>
        <value>localhost</value>
    </property>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>hbase.zookeeper.property.clientPort</name>
        <value>2181</value>
    </property>
    <property>
        <name>hbase.zookeeper.property.dataDir</name>
        <value>~/opt/hbase-1.1.4/zookeeper</value>
    </property>
9.  Start the Hbase daemons:
    <pre><code>start-hbase.sh</code></pre>
    To ensure everything is working, run the `jps` command and you should be able to get the following. If you didn't get them all, then please check your configurations:
    <pre><i>HQuorumPeer
    HMaster
    HRegionServer</i></pre>
    <br />
10. To login into HBase shell:
    <pre><code>hbase shell</code></pre>
---
### 5. Install Airflow
1. Let's first install `pip` for linux:
    <pre><code>sudo apt-get install python3-pip python-dev</code></pre>
2. Verify the installation:
    <pre><code>pip3  --version</code></pre>
3. Let's create an `airflow` directory, and inside this directory, let's also create a `dags` directory. This is where we’ll store our python dag files:
    <pre><code> mkdir ~/airflow
    cd ~/airflow
    mkdir dags</code></pre>

4. (Optional) uninstall any old apache-airflow installations using pip:
    <pre><code>sudo pip3 uninstall apache-airflow</code></pre>
5. Install apache-airflow using pip:
    <pre><code>sudo pip3 install apache-airflow</code></pre>
6. Initialize apache-airflow database (default is sqlite):
    <pre><code>airflow db init</code></pre>
7. Create admin user and password:
    <pre><code> airflow users create \
	--username admin \
	--firstname [YOUR_FIRST_NAME] \ 
	--lastname [yOUR_LAST_NAME] \
	--role Admin \
	--email spiderman@superhero.org</code></pre>
8. Open another terminal, start the web server and let it run:
    <pre><code>airflow web server --port 8080</code></pre>
9. Open another terminal, start the scheduler and let it run:
    <pre><code>airflow scheduler</code></pre>
10. Visit `localhost:8080` in the browser to access the GUI
11. Enter your username and password (from step 8)

