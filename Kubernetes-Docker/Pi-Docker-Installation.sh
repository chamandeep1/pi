#Reading system date and time and updating file name for logs
now=$(date +'%m-%d-%y-%H'HH'-%M'MM'')
file="log-"$now".txt"

#Updating and Upgrading linux system
echo -e "${colr}Starting system update"
sudo apt-get update > ../$file
echo -e "${colr}Initial Saving: "$file" after Update"
echo -e "${colr}Starting system upgrade"
sudo apt-get upgrade -y >> ../$file
echo -e "${colr}apt-get Upgrade complete"

#setting up nano to display linenumber
sudo sed -i "s/^# set linenumbers/set linenumbers/g" /etc/nanorc
echo "Nano setup to display line number"

#To install docker on raspberry-Pi Ubuntu server:
sudo apt install docker.io -y >> ../$file
echo "Docker installed on Pi"

#Do following to give user permisson to run dockers:
sudo usermod -a -G docker $USER >> ../$file
echo "User Pi given root permission to run docker"

#installing prerequisite for docker compose
#https://www.techiebouncer.com/2019/11/install-docker-and-docker-compose-on.html
sudo apt-get install libffi-dev libssl-dev -y >> ../$file
sudo apt install python3-dev -y >> ../$file
sudo apt-get install -y python3 python3-pip -y >> ../$file
echo "Docker compose proereqisites installed"

#Install docker compose
sudo pip3 install docker-compose >> ../$file
echo "Docker compose installed"

#Running helloworld on docker
docker run hello-world >> ../$file
echo "Docker Hello World run succesfully"

#Running docker compose to compose the file 
docker-compose up -d
