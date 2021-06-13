# Spark on AWS VM

Useless ?
yum install git

yum install java-1.8.0-openjdk python3 awscli git


cd ~/go2s3/spark
mkdir archives

from gha-workbench/archives

scp hadoop-3.2.0.tar.gz  n0.single1.vpc2:~/go2s3/spark/archives/
scp spark-3.1.1-bin-hadoop3.2.tgz  n0.single1.vpc2:~/go2s3/spark/archives/

tar xvzf archives/spark-3.1.1-bin-hadoop3.2.tgz
mv spark-3.1.1-bin-hadoop3.2 spark-3.1.1
ls ./spark-3.1.1/jars/hadoop*.jar
tar xvzf archives/hadoop-3.2.0.tar.gz
cp ./hadoop-3.2.0/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar spark-3.1.1/jars
cp ./hadoop-3.2.0/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar spark-3.1.1/jars
rm -rf hadoop-3.2.0/

Check installation:

cd spark-3.1.1/
./bin/run-example SparkPi 10
./bin/spark-submit examples/src/main/python/pi.py 10

Fulfill some data

Deploy gha2s3

cd ../gha2s3

python py/main.py --s3Type aws --bucketFormat gha1-primary-1 --maxDownloads 1 --workDir /tmp --accessKey AKIAX......V7YLFQ --secretKey XXXXXXXXXXXXXXXXXXXX

python py/main.py --s3Type aws --bucketFormat gha-common-1 --maxDownloads 1 --workDir /tmp
python py/main.py --s3Type aws --bucketFormat gha1-primary-1 --maxDownloads 1 --workDir /tmp --assumeRole single1_gha1

./submit-local.sh Count --srcPath s3a://gha-common-1/raw

export SPARK_LOCAL_DIRS=/home/sa/go2s3/spark/tmp/

time ./submit-local.sh Json2Parquet --srcBucketFormat gha-common-1 --dstBucketFormat gha-common-1 --maxFiles 1

aws s3 rm --recursive s3://gha-common-1/raw/src=2021-06-10-00

In all .../tmp:
watch -n 1 "du -hs *"

time ./submit-local.sh Json2Parquet --srcBucketFormat gha1-primary-1 --dstBucketFormat gha1-secondary-1 --maxFiles 1 --backDays 0

aws s3 --profile gha1 rm --recursive s3://gha1-secondary-1/raw/year=2021/month=06/day=09/hour=00

Long running
./submit-local.sh Json2Parquet --srcBucketFormat gha1-primary-1 --dstBucketFormat gha1-secondary-1 --maxFiles 100 --backDays 0 --waitSeconds 900
