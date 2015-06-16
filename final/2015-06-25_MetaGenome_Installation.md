# Metagenome program installation

For this course, we will be using a set of independently developed programs for our metagenome analysis. While some of the programs are already installed on your EC2 instance there are a few remaining that we will download and install together as a class. These include the FastX toolkit and one of its dependencies Libgtextutils, as well as Khmer. You will need to be running an m3.large EC2 instance from the AMI `EDAMAME-2015` with 100GB of storage.   

####Downloading, Unpacking, and Installing Libgtextutils and FastX:
In order to install FastX and libgtextutils we will do three basic steps. First we will download a compressed version of the programs using `wget`. Then we will unzip those folders using `tar` and finally we will install configure and install the programs. The code for install these two programs are listed below. 

#####For libgtextutils 
```
wget https://github.com/agordon/libgtextutils/releases/download/0.7/libgtextutils-0.7.tar.gz
tar -zxvf libgtextutils-0.7.tar.gz
cd libgtextutils-0.7
./configure
make
sudo make install
```

#####For FastX:
```
wget https://github.com/agordon/fastx_toolkit/releases/download/0.0.14/fastx_toolkit-0.0.14.tar.bz2
tar -xjf fastx_toolkit-0.0.14.tar.bz2
cd fastx_toolkit-0.0.14
./configure
make
sudo make install
```

####Installing Khmer: 
While installing khmer, we will do things slightly differently. We will start by moving into the directory /usr/local/share/ and the use the command `git clone` to download the khmer programs. We'll then change into the new directory using `cd` and then install khmer. 
```
cd /usr/local/share/
sudo git clone https://github.com/ged-lab/khmer.git
cd khmer
sudo git checkout protocols-v0.8.3
sudo make

echo 'export PYTHONPATH=/usr/local/share/khmer:$PYTHONPATH' >> ~/.bashrc
source ~/.bashrc
```

####Installing screed:
```
sudo pip install screed
```




