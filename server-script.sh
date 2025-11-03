# sudo yum install java -y
sudo yum install git -y
# sudo yum install maven -y
sudo yum install docker -y
sudo service docker start


if [ -d "addressbook-v1" ]
then
  echo "repo is cloned and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin master
else
  git clone https://github.com/preethid/addressbook-v1.git
fi

cd /home/ec2-user/addressbook-v1
#mvn package

sudo docker build -t $1 .