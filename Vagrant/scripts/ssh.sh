sudo yum -y install openssh-server openssh-client
ssh-keygen -t rsa -P ""
ssh-copy-id vagrant@192.168.1.209
ssh-copy-id vagrant@192.168.1.210
