sudo cat <<EOF >> /etc/hosts
192.168.1.207 Kafka1
192.168.1.211 Kafka2
192.168.1.212 Kafka3
192.168.1.213 flink
192.168.1.214 flink1
192.168.1.215 flinkw1
192.168.1.216 flinkw2
192.168.1.217 flinkw3
EOF

ssh-keygen -t rsa -P ""
ssh-copy-id 192.168.1.213
ssh-copy-id 192.168.1.214
ssh-copy-id 192.168.1.215
ssh-copy-id 192.168.1.216
ssh-copy-id 192.168.1.217

wget https://www-eu.apache.org/dist/flink/flink-1.7.0/flink-1.7.0-bin-hadoop28-scala_2.12.tgz
tar -zxvf flink-1.7.0-bin-hadoop28-scala_2.12.tgz
export FLINK_HOME=/home/vagrant/flink-1.7.0/
export PATH=$PATH:$FLINK_HOME/bin
sudo sed -i 's/^jobmanager.rpc.address: localhost$/jobmanager.rpc.address: flink/g' /home/vagrant/flink-1.7.0/conf/flink-conf.yaml

sudo cat <<EOF >> /home/vagrant/flink-1.7.0/conf/slaves
flinkw1
flinkw2
flinkw3
EOF

sudo sed -i 's/^# high-availability: zookeeper$/high-availability: zookeeper/g' /home/vagrant/flink-1.7.0/conf/flink-conf.yaml
sudo sed -i 's/^# high-availability.zookeeper.quorum: localhost:2181$/high-availability.zookeeper.quorum: kafka1:2181,kafka2:2181,kafka3:2181/g' /home/vagrant/flink-1.7.0/conf/flink-conf.yaml
sudo sed -i 's/^# high-availability.storageDir: hdfs:\/\/\/flink\/ha\/$/# high-availability.storageDir: hdfs:\/\/\/flink\/ha\//g' /home/vagrant/flink-1.7.0/conf/flink-conf.yaml
sudo sed -i '/# high-availability.zookeeper.client.acl: open/ a high-availability.zookeeper.path.root: /flink' /home/vagrant/flink-1.7.0/conf/flink-conf.yaml
sudo sed -i '/# high-availability.zookeeper.client.acl: open/ a high-availability.zookeeper.path.cluster-id: /map_flink' /home/vagrant/flink-1.7.0/conf/flink-conf.yaml

sudo sed -i 's/^localhost:8081$/flink:8081/g' /home/vagrant/flink-1.7.0/conf/masters
sudo sed -i '/flink:8081/ a flink1:8081' /home/vagrant/flink-1.7.0/conf/masters

sudo sed -i '/server.1=localhost:2888:3888/ a server.2=kafka2:2888:3888' /home/vagrant/flink-1.7.0/conf/zoo.cfg
sudo sed -i '/server.1=localhost:2888:3888/ a server.3=kafka3:2888:3888' /home/vagrant/flink-1.7.0/conf/zoo.cfg
sudo sed -i 's/^server.1=localhost:2888:3888$/server.1=kafka1:2888:3888/g' /home/vagrant/flink-1.7.0/conf/zoo.cfg
sudo sed -i 's/^initLimit=10$/initLimit=20/g' /home/vagrant/flink-1.7.0/conf/zoo.cfg
sudo sed -i 's/^syncLimit=5$/syncLimit=10/g' /home/vagrant/flink-1.7.0/conf/zoo.cfg


#Run Command on Master
$bin/start-cluster.sh
$bin/stop-cluster.sh

http://<Master-IP>:8081
