####========================================================
### Remove Old Python 3.6u Dependencies
####========================================================
yum -y remove python36u python36u-devel python36u-pip python36u-setuptools python36u-tools python36u-libs python36u-tkinter

####========================================================
### Install Python 3.6 Dependencies
####========================================================
yum -y install python36 python36-devel python36-pip python36-setuptools python36-tools python36-libs python36-tkinter gcc-c++
yum -y install cmake3 cmake3-data
python3 --version
pip3 install wheel pandas numpy scipy scikit-learn matplotlib virtualenv

####========================================================
### Install Jupyter
####========================================================
pip3 install jupyter
