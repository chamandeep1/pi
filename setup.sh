#Following commands need to be run manually
#sudo apt-get install git
#git clone https://github.com/chamandeep1/pi.git
#cd pi
#chmod +x setup.sh (Optional - if the file is not ececutable)
#./setup.sh

#setting colour for comments in shell script
#https://misc.flogisoft.com/bash/tip_colors_and_formatting
colr='\e[33m\e[48;5;21m' #yellow text with blue background

#Reading system date and time and updating file name
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
#https://unix.stackexchange.com/questions/15594/is-there-line-numbering-for-nano
sudo sed -i "s/^# set linenumbers/set linenumbers/g" /etc/nanorc
echo "Nano setup to display line number"

#Upgrading pip3
echo -e "${colr}Starting pip3 upgrade"
sudo -H pip3 install --upgrade pip >> ../$file
echo -e "${colr}pip3 upgrade complete"

#Installing Jupyter Notebook 
echo -e "${colr}Starting jupyter install"
sudo pip3 install jupyter >> ../$file
echo -e "${colr}jupyter install complete"
jupyter notebook --generate-config >> ../$file #do not use SUDO for this command as it will create config for root user 
echo -e "${colr}jupyter  notebook generate config completed"
#jupyter notebook password
#csingh
#csingh
#echo 'juputer notebook password set'
#Notebook Hash for first time to be checked with following command
#jupyter notebook list

#Update jupyter_notebook_config.py to allow all IP address
sed -i "s/^#c.NotebookApp.allow_origin.*/c.NotebookApp.allow_origin = '*'/g" /home/pi/.jupyter/jupyter_notebook_config.py
sed -i "s/^#c.NotebookApp.ip.*/c.NotebookApp.ip = '0.0.0.0'/g" /home/pi/.jupyter/jupyter_notebook_config.py
echo -e "${colr}jupyter_notebook_config.py updated to allow all IP address"

#Automating startup of Vncserver and Jupyter Notebook
echo "!/bin/bash
vncserver
export PATH="$PATH/usr/local/bin/"
jupyter notebook --no-browser --notebook-dir='/home/pi/Documents' &" >> startup.sh
sudo cp startup.sh /usr/bin/startup.sh
rm startup.sh
sudo chmod +x /usr/bin/startup.sh
sudo sed -i '/^exit 0/i su pi -c "bash /usr/bin/startup.sh"' /etc/rc.local
echo -e "${colr}Jupyter Notebook Setup Completed"

#Installing Tensorflow
echo -e "${colr}Starting Tensorflow installation"
sudo apt-get install libatlas-base-dev -y >> ../$file
sudo pip3 install tensorflow >> ../$file
echo -e "${colr}Tensorflow installation completed"
#In setup check if this is required:
#https://pypi.org/project/setuptools-markdown/
#pip install setuptools-markdown

#Installing h5py to load already saved model in Pi 
#Link: https://www.tensorflow.org/tutorials/keras/save_and_restore_models
#sudo apt-get install libhdf5-dev --> check if this one is really required in new installation
sudo apt-get install icu-devtools libicu-dev libxml2-dev libxslt1-dev -y >> ../$file
sudo pip install -q h5py pyyaml >> ../$file
echo -e "${colr}For tensorflow h5py updated"

#Installing Jupyter Extensions
sudo apt-get install libxslt-dev >> ../$file
sudo pip install jupyter_nbextensions_configurator jupyter_contrib_nbextensions >> ../$file
jupyter contrib nbextension install --user
jupyter nbextensions_configurator enable --user
echo -e "${colr}Jupyter Extensions installation and enabling user completed, script completion will do restart"

#Installing OpenCV, taken from following websites
#https://github.com/amymcgovern/pyparrot/issues/34
#https://stackoverflow.com/questions/37495375/python-pip-install-throws-typeerror-unsupported-operand-types-for-retry
echo -e "${colr}Starting OpenCV installation"
sudo pip install --upgrade pip
#For Raspberry Pi 4 use following command
#https://raspberrypi.stackexchange.com/questions/100253/how-can-i-install-opencv-on-raspberry-pi-4-raspbian-buster
sudo apt install python-opencv
sudo apt install python3-opencv
#For Raspberry Pi 3 use folowing command
#sudo pip3 install opencv-python
sudo apt-get install libatlas-base-dev -y
sudo apt-get install libjasper-dev -y
sudo apt-get install libqtgui4 -y
sudo apt install libqt4-test -y
sudo apt-get install python3-pyqt5 -y
echo -e "${colr}Completed OpenCV installation"

#Check if OpenCV contrib is to be installed
#https://stackoverflow.com/questions/47113029/importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-or-directo
#sudo python3 -m pip install opencv-contrib-python

#Installing Pandas
echo -e "${colr}Starting Pandas installation"
sudo pip3 install pandas >> ../$file
echo -e "${colr}Pandas installation completed"

#Installing Matplotlib
sudo apt-get install python3-matplotlib -y >> ../$file
echo -e "${colr}Matplotlib installation completed"

#Installing gparted on the SD card
sudo apt-get install gparted -y >> ../$file
echo -e "${colr}gparted installation completed"

#Creating Swap space in SD Card for 4GB and initializing it on every startup
#Link: https://linuxize.com/post/create-a-linux-swap-file/
#sudo fallocate -l 4G /swapfile
#sudo chmod 600 /swapfile
#sudo mkswap /swapfile
#sudo swapon /swapfile
#sudo sed -i '/^# a/i /swapfile swap swap defaults 0 0' /etc/fstab
#echo -e "${colr}Swap space of 4GB setup"

#Increasing swap to 1GB
echo -e "${colr}Increasing swap size to 1GB"
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
echo -e "{colr}Completed swap space increase to 1GB"

#Rebooting the system for matplotlib to take effect
echo -e "${colr}Please Reboot Environment"

#Make entry into crontab to start shell script on reboot
#https://stackoverflow.com/questions/4880290/how-do-i-create-a-crontab-through-a-script
#(crontab -l 2>/dev/null; echo "@reboot /home/pi/Documents/pi/OpenCV/opencv.sh") | crontab -

#sudo reboot
