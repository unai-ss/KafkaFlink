#https://progressive-code.com/post/17/Setup-a-Kafka-cluster-with-3-nodes-on-CentOS-7

## en todos los nodos
Retirar el 127.0.0.1 Kafka1 (no necesario si zookeeper bien configurado)

sudo cat <<EOF >> /etc/hosts
192.168.1.207 Kafka1
192.168.1.211 Kafka2
192.168.1.212 Kafka3
EOF

sudo cat <<EOF >> /etc/hosts
192.168.1.2 Kafka1
192.168.1.11 Kafka2
192.168.1.12 Kafka3
EOF

## en todos los nodos como usuario vagrant
mkdir -p /home/vagrant/kafka/zookeeper/data
mkdir -p /home/vagrant/kafka/kafka-logs
## en todos los nodos como vagrant


sudo cat <<EOF >>/home/vagrant/kafka/config/zookeeper.properties
maxClientCnxns=200
tickTime=2000
server.1=0.0.0.0:2888:3888  (dependiendo del nodo que estemos)
server.2=kafka2:2888:3888
server.3=kafka3:2888:3888
initLimit=20
syncLimit=10
EOF

## en todos los nodos como vagrant
echo "1" > /home/vagrant/kafka/zookeeper/data/myid
sudo sed -i 's/^broker.id=0$/broker.id=1/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^log.dirs=\/tmp\/kafka-logs$/log.dirs=\/home\/vagrant\/kafka\/kafka-logs/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^#listeners=PLAINTEXT:\/\/:9092$/listeners=PLAINTEXT:\/\/kafka1:9092/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092$/advertised.listeners=PLAINTEXT:\/\/kafka0:9092/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^zookeeper.connect=localhost:2181$/zookeeper.connect=kafka1:2181,kafka2:2181,kafka3:2181/g' /home/vagrant/kafka/config/server.properties
echo "2" > /home/vagrant/kafka/zookeeper/data/myid
sudo sed -i 's/^broker.id=0$/broker.id=2/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^log.dirs=\/tmp\/kafka-logs$/log.dirs=\/home\/vagrant\/kafka\/kafka-logs/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^#listeners=PLAINTEXT:\/\/:9092$/listeners=PLAINTEXT:\/\/kafka2:9092/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092$/advertised.listeners=PLAINTEXT:\/\/kafka1:9092/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^zookeeper.connect=localhost:2181$/zookeeper.connect=kafka1:2181,kafka2:2181,kafka3:2181/g' /home/vagrant/kafka/config/server.properties
echo "3" > /home/vagrant/kafka/zookeeper/data/myid
sudo sed -i 's/^broker.id=0$/broker.id=3/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^log.dirs=\/tmp\/kafka-logs$/log.dirs=\/home\/vagrant\/kafka\/kafka-logs/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^#listeners=PLAINTEXT:\/\/:9092$/listeners=PLAINTEXT:\/\/kafka3:9092/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092$/advertised.listeners=PLAINTEXT:\/\/kafka2:9092/g' /home/vagrant/kafka/config/server.properties
sudo sed -i 's/^zookeeper.connect=localhost:2181$/zookeeper.connect=kafka1:2181,kafka2:2181,kafka3:2181/g' /home/vagrant/kafka/config/server.properties

##en todos los nodos
sudo systemctl status kafka

##Create topics
bin/kafka-topics.sh --create --zookeeper kafka1:2181,kafka2:2181,kafka3:2181 --replication-factor 1 --partitions 6 --topic topic1 --config cleanup.policy=delete --config delete.retention.ms=60000
bin/kafka-topics.sh --list --zookeeper kafka1:2181
bin/kafka-topics.sh --describe --zookeeper kafka1:2181 --topic topic1
##Test the cluster
bin/kafka-console-producer.sh --broker-list kafka1:9092 --topic topic1
bin/kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic topic1
