#Following commands need to be run manually
#sudo apt-get install git
#git clone https://github.com/chamandeep1/pi.git
#cd pi
#chmod +x setup.sh
#./setup.sh


#Reading system date and time and updating file name
now=$(date +'%m-%d-%y-%H'HH'-%M'MM'')
file="log-"$now".txt"

#Updating and Upgrading linux system
sudo apt-get update > ../$file
echo 'Initial Saving: '$file' after Update'
sudo apt-get upgrade -y >> ../$file
echo 'apt-get Upgrade complete'

#Upgrading pip3
sudo -H pip3 install --upgrade pip >> ../$file
echo 'pip3 upgrade complete'

#Installing Jupyter Notebook 
sudo pip3 install jupyter >> ../$file
echo 'jupyter install complete'
jupyter notebook --generate-config >> ../$file
echo 'jupyter  notebook generate config completed'
#jupyter notebook password
#csingh
#echo 'juputer notebook password set'

#Update jupyter_notebook_config.py to allow all IP address
sed -i "s/^#c.NotebookApp.allow_origin.*/c.NotebookApp.allow_origin = '*'/g" /home/pi/.jupyter/jupyter_notebook_config.py
sed -i "s/^#c.NotebookApp.ip.*/c.NotebookApp.ip = '0.0.0.0'/g" /home/pi/.jupyter/jupyter_notebook_config.py
echo 'jupyter_notebook_config.py updated to allow all IP address'

#Automating startup of Vncserver and Jupyter Notebook
echo "!/bin/bash
vncserver
export PATH="$PATH/usr/local/bin/"
jupyter notebook --no-browser --notebook-dir='/home/pi/Documents' &" >> startup.sh
sudo cp startup.sh /usr/bin/startup.sh
rm startup.sh
sudo chmod +x /usr/bin/startup.sh
sudo sed -i '/^exit 0/i su pi -c "bash /usr/bin/startup.sh"' /etc/rc.local
echo 'Setup Completed'
