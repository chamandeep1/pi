#Installing from following location:
#www.alatortsev.com/2018/11/21/installing-opencv-4-0-on-raspberry-pi-3-b/

#Reading system date and time and updating file name
now=$(date +'%m-%d-%y-%H'HH'-%M'MM'')
file="log-OpenCV-"$now".txt"

sudo apt-get update > ../$file 
echo "apt-get Update completed"
sudo apt-get upgrade -y >> ../$file
echo "apt-get Upgrade completed"
echo "Starting dependencies installation"
sudo apt-get install build-essential cmake pkg-config >> ../$file
sudo apt-get install libjpeg-dev libtiff-dev libjasper-dev libpng12-dev >> ../$file
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev >> ../$file
sudo apt-get install libxvidcore-dev libx264-dev >> ../$file
sudo apt-get install libgtk2.0-dev libgtk-3-dev >> ../$file
sudo apt-get install libatlas-base-dev gfortran >> ../$file
echo "Completed dependencies installation"
sudo apt-get install python3-dev >> ../$file
echo "Downloading latest Opencv"
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip
unzip opencv.zip
unzip opencv_contrib.zip
echo "Commpleted opencv download"
echo " Starting Numpy and Scipy Installation"
cd ~/opencv-4.0.0/
mkdir build
cd build
echo "Compiling Opencv"
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-4.0.0/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D WITH_FFMPEG=ON \
    -D WITH_GSTREAMER=ON \
    -D BUILD_EXAMPLES=ON .. >> ../$file
echo "Starting Opencv Build"
make -j4 >> ../$file
echo "Opencv Build Completed"
echo "Starting Opencv install"
sudo make install >> ../$file
echo "Opencv Installation completed"
sudo ldconfig >> ../$file
sudo apt-get update >> ../$file
