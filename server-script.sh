#! /bin/bash -x 
# sudo yum install java-17-amazon-corretto-devel -y
sudo yum install git -y
# sudo yum install maven -y
sudo yum install docker -y
sudo service docker start

if [ -d "addressbook-v1" ]
then
  echo "repo is cloned and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin demo-5
else
  git clone https://github.com/preethid/addressbook-v1.git
  git checkout demo-5
fi

cd /home/ec2-user/addressbook-v1
# mvn compile
git checkout demo-5
sudo docker build -t $1:$2 .