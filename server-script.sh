sudo yum install java-17-amazon-corretto-devel -y
sudo yum install git -y
sudo yum install maven -y

if [ -d "addressbook-v1" ]
then
  echo "repo is cloned and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin project2
else
  git clone https://github.com/preethid/addressbook-v1.git
fi

cd /home/ec2-user/addressbook-v1
mvn compile
