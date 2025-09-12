# //sudo yum install java-17-amazon-corretto-devel -y
# sudo/ yum install java -y
sudo yum install git -y
# sudo wget http://mirror.olnevhost.net/pub/apache/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
# sudo tar xvf apache-maven-3.9.9-bin.tar.gz
# sudo mv apache-maven-3.9.9  /usr/local/apache-maven

# sudo export M2_HOME=/usr/local/apache-maven
# sudo export M2=$M2_HOME/bin 
# sudo export PATH=$M2:$PATH
# sudo source ~/.bashrc
# sudo yum install apache-maven -y
# sudo yum install maven -y

sudo yum install docker -y
sudo systemctl start docker



if [ -d "addressbook-v1" ]
then
  echo "repo is cloned and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin argocd-demo
else
  git clone https://github.com/preethid/addressbook-v1.git
fi

cd /home/ec2-user/addressbook-v1
git checkout argocd-demo
# mvn compile
sudo docker build -t $1:$2 .
