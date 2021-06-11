#!/bin/bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASEDIR="$(cd .. && pwd)"


GHA2SPARK=$BASEDIR/../gha2spark

cd $GHA2SPARK && ./gradlew
if [ $? -ne 0 ]
then
  exit 1
fi


scp $GHA2SPARK/build/libs/gha2spark-0.1.1-uber.jar n0.single1.vpc2:/home/sa/go2s3/spark

#aws s3 --profile cagip cp $GHA2SPARK/build/libs/gha2spark-0.1.0-uber.jar s3://gha1-spark/spark/jars/gha2spark-0.1.0-uber.jar

#mc policy set download ${MC_ALIAS}/spark/jars/gha2spark-0.1.0-uber.jar

