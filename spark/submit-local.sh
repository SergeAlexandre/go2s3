
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ACTION_CLASS=$1
shift


cd $MYDIR/spark-3.1.1 && ./bin/spark-submit --master local \
--driver-java-options "-Dlog4j.configuration=file:$MYDIR/spark-3.1.1/conf/log4j.properties"  \
--class gha2spark.${ACTION_CLASS} ../gha2spark-0.1.1-uber.jar "$@"



