#https://data-flair.training/blogs/apache-flink-cluster/
#http://www.bigdataqubes.com/posts/multi-node-apache-flink-cluster.php
sudo mkdir -p /opt && sudo cd /opt
sudo wget http://www-eu.apache.org/dist/flink/flink-1.7.0/flink-1.7.0-bin-hadoop28-scala_2.12.tgz
sudo tar xzf flink-1.7.0-bin-hadoop28-scala_2.12.tgz
export FLINK_HOME=/home/vagrant/flink-1.7.0/
export PATH=$PATH:$FLINK_HOME/bin
sudo sh -c "echo FLINK_HOME=/home/vagrant/flink-1.7.0/ >> /etc/environment"
sudo sh -c "echo export PATH=$PATH:$FLINK_HOME/bin >> ~./bahsrc"
sed -i 's/^jobmanager.rpc.address:$/jobmanager.rpc.address: ZooK1/g' $FLINK_HOME/conf/flink-conf.yaml
sudo sh -c "echo ZooK2 >> $FLINK_HOME/conf/slaves"
sudo sh -c "echo ZooK3 >> $FLINK_HOME/conf/slaves"
sudo sh -c "echo 192.168.1.208  ZooK1 >> /etc/hosts"
sudo sh -c "echo 192.168.1.209  ZooK2 >> /etc/hosts"
sudo sh -c "echo 192.168.1.210  ZooK3 >> /etc/hosts"
sudo systemctl stop firewalld
sudo setenforce 0
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
