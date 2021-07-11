####============================================================
### Note: Please install the `install_py3.sh` before continuing
####============================================================

####============================================================
### login as root
####============================================================
sudo su -
sandbox-version

####============================================================
### Setup folders and files
####============================================================
jupyter notebook --generate-config
sudo mkdir -p /ibm/conf
sudo chown -R spark:hadoop /ibm
cp ~/.jupyter/jupyter_notebook_config.py /ibm/conf/

####============================================================
### Setup startup shell script
####============================================================
cd /ibm
mkdir scripts
cd scripts/
vi start_jupyter.sh

#copy the paste the following contents

#! bin/bash
set -x
USER=$1
JUPYTER_HOST=sandbox-hdp.hortonworks.com
JUPYTER_PORT=8889
su - ${USER} <<EOF
export SPARK_HOME=/usr/hdp/current/spark2-client
export PYSPARK_SUBMIT_ARGS="--master yarn-client pyspark-shell"
export HADOOP_HOME=/usr/hdp/current/hadoop-client
export HADOOP_CONF_DIR=/usr/hdp/current/hadoop-client/conf
export PYTHONPATH="/usr/hdp/current/spark2-client/python:/usr/hdp/current/spark2-client/python/lib/py4j-0.10.6-src.zip"
export PYTHONSTARTUP=/usr/hdp/current/spark2-client/python/pyspark/shell.py
export PYSPARK_SUBMIT_ARGS="--master yarn-client pyspark-shell"
echo "Starting Jupyter daemon on HDP Cluster ..."
jupyter notebook --config=/ibm/conf/jupyter_notebook_config.py --ip=${JUPYTER_HOST} --port=${JUPYTER_PORT}&
EOF
exit 0

####============================================================
### Run startup shell script
####============================================================

chown -R spark:hadoop /ibm
chmod 777 /ibm/scripts/start_jupyter.sh
cd /ibm/scripts
bash start_jupyter.sh spark

####============================================================
### Copy the link from above step's output and paste to your computer's browser
####============================================================
# make sure you define sandbox.hortonworks.com in your hosts file
# http://sandbox.hortonworks.com:8889/?token=c982c0f95222abcf2900e3aeb9d9c59cc0386cc04c6c154d
