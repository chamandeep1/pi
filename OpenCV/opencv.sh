#Installing from following location:
#https://www.learnopencv.com/install-opencv-4-on-raspberry-pi/

#Reading system date and time and updating file name
now=$(date +'%m-%d-%y-%H'HH'-%M'MM'')
file="log-OpenCV-"$now".txt"

#Step 0: Select OpenCV version to install
cvVersion="master"
mkdir installation
mkdir installation/OpenCV-"$cvVersion"
cwd=$(pwd)

#Step 1: Update Packages
echo "Starting Update and Upgrade"
sudo apt -y update > ../../$file
sudo apt -y upgrade >> ../../$file
echo " Update and Upgrade completed"

#Step 2: Install OS Libraries
echo "Starting to Install Prerequisits"
sudo apt-get -y remove x264 libx264-dev >> ../../$file
sudo apt-get -y install build-essential checkinstall cmake pkg-config yasm >> ../../$file
sudo apt-get -y install git gfortran >> ../../$file
sudo apt-get -y install libjpeg8-dev libjasper-dev libpng12-dev >> ../../$file
sudo apt-get -y install libtiff5-dev >> ../../$file
sudo apt-get -y install libtiff-dev >> ../../$file
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev >> ../../$file
sudo apt-get -y install libxine2-dev libv4l-dev >> ../../$file
cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h
cd $cwd
sudo apt-get -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev >> ../../$file
sudo apt-get -y install libgtk2.0-dev libtbb-dev qt5-default >> ../../$file
sudo apt-get -y install libatlas-base-dev >> ../../$file
sudo apt-get -y install libmp3lame-dev libtheora-dev >> ../../$file
sudo apt-get -y install libvorbis-dev libxvidcore-dev libx264-dev >> ../../$file
sudo apt-get -y install libopencore-amrnb-dev libopencore-amrwb-dev >> ../../$file
sudo apt-get -y install libavresample-dev >> ../../$file
sudo apt-get -y install x264 v4l-utils >> ../../$file
echo "Prerequisits Installation completed"
# Optional dependencies
echo "Starting Optional dependencies installation"
sudo apt-get -y install libprotobuf-dev protobuf-compiler >> ../../$file
sudo apt-get -y install libgoogle-glog-dev libgflags-dev >> ../../$file
sudo apt-get -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen >> ../../$file
echo "Completed optional dependencies insatllation"

#Step 3: Install Python Libraries
echo "Starting python library installation"
sudo apt-get -y install python3-dev python3-pip >> ../../$file
sudo -H pip3 install -U pip numpy >> ../../$file
sudo apt-get -y install python3-testresources >> ../../$file
echo "Completed python libraries installation"

#Makint the swap size to 3GB, otherwise thare is memory issues for complete compilation.
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=3072/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
#Folling dlib is optional machine learning library in case you want to install.
#pip install dlib

#Step 4: Download opencv and opencv_contrib
echo "Starting Git clone" >> ../../$file
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout $cvVersion
cd ..
 
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout $cvVersion
cd ..
echo "Completed git clone" >> ../../$file

#Step 5: Compile and install OpenCV with contrib modules
cd opencv
mkdir build
cd build

echo "Starting Build cmake"
# Modified below cmake command to include -D ENABLE_PRECOMPILED_HEADERS=OFF \ and 
# -D BUILD_LIBPROTOBUF_FROM_SOURCES=ON \ , this will build from source and can take upto 15 hours 
cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=$cwd/installation/OpenCV-"$cvVersion" \
            -D INSTALL_C_EXAMPLES=ON \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D WITH_TBB=ON \
            -D WITH_V4L=ON \
            -D OPENCV_PYTHON3_INSTALL_PATH=$cwd/OpenCV-$cvVersion-py3/lib/python3.5/site-packages \
            -D ENABLE_PRECOMPILED_HEADERS=OFF \	
	    -D BUILD_LIBPROTOBUF_FROM_SOURCES=ON \
	-D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON ..
echo "Completed build"

echo "Staring Make"
make -j$(nproc) >> ../../$file
echo "Completed Make"
echo "Starting OpenCV installation"
make install >> ../../$file
echo "Completed OpenCV installation"

#For import error on Python2.7 install following , This maybe also required for python 3.X so install.
sudo apt install python-opencv >> ../../$file

#For import error "ImportError: libQtGui.so.4", solution is at following site
#https://github.com/pageauc/opencv3-setup/issues/3
sudo apt install libqtgui4 >> ../../$file

#For import error "ImportError: libQtTest.so.4:", solution is at following site #https://stackoverflow.com/questions/49799798/can-not-import-opencv-in-python3-in-raspberry-pi3
sudo apt install libqt4-test >> ../../$file

#Optional to run below command.
#echo "sudo modprobe bcm2835-v4l2" >> ~/.profile

#Below command needs to be run in case crontab is used to autostart this file.
#crontab -u pi -l | grep -v '@reboot /home/pi/test2.sh'  | crontab -u pi -
#echo "Removed entry from crontab to start opencv.sh on reboot"

#sudo reboot
