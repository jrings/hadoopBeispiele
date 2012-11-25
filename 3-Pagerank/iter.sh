# CONFIGURATION
CLEANUP=0 #Set to 1 to delete temporary folder at the end
MRDIR="$( cd "$( dirname "$0" )" && pwd )"
TEMPDIR=$MRDIR/temp
ALPHA=0.85
mkdir $TEMPDIR

cp $MRDIR/graph.txt $TEMPDIR/graph_.txt
cut -f 3- -d " " $MRDIR/graph.txt > $TEMPDIR/adja.txt

for i in {1..10}
do
    echo "Iteration $i"
    hadoop fs -rm -r pagerank graph_.txt
    hadoop fs -copyFromLocal $TEMPDIR/graph_.txt graph_.txt
    hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -D stream.num.map.output.key.fields=1 -D mapred.text.key.comparator.options=-k1n -file $MRDIR/weightMapper.py -mapper weightMapper.py -file $MRDIR/weightReducer.py -reducer weightReducer.py -input graph_.txt -output pagerank
    if [[ $? != 0 ]]; then
	echo "Run unsuccessful!"
	exit $?
    fi
    rm -rf $TEMPDIR/pagerank
    hadoop fs -copyToLocal pagerank $TEMPDIR
    cat $TEMPDIR/pagerank/part*  > $TEMPDIR/output.txt

    #Write parameters for alpha, graph size and cumulative hanging weight
    echo $ALPHA > $TEMPDIR/data_.txt
    tail -n 1 $TEMPDIR/graph_.txt | awk '{print $1+1}' >> $TEMPDIR/data_.txt
    head -n 1 $TEMPDIR/output.txt | awk '{print $2}' >> $TEMPDIR/data_.txt

    hadoop fs -rm -r pageout output.txt
    hadoop fs -copyFromLocal $TEMPDIR/output.txt output.txt
    hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar -D mapred.output.key.comparator.class=org.apache.hadoop.mapred.lib.KeyFieldBasedComparator -D stream.num.map.output.key.fields=1 -D mapred.text.key.comparator.options=-k1n -file $MRDIR/alphaMapper.py -mapper alphaMapper.py -reducer alphaReducer.py -file $MRDIR/alphaReducer.py -file $TEMPDIR/data_.txt -input output.txt -output pageout
    if [[ $? != 0 ]]; then
	echo "Run unsuccessful!"
	exit $?
    fi
    rm -rf $TEMPDIR/pageout
    hadoop fs -copyToLocal pageout $TEMPDIR
    cat $TEMPDIR/pageout/part*  > $TEMPDIR/out.txt
    paste $TEMPDIR/out.txt $TEMPDIR/adja.txt > $TEMPDIR/graph_.txt
done

cat $TEMPDIR/graph_.txt | sort -k2g | head -n 10

if [[ $CLEANUP == 1 ]]; then
    rm -rf $TEMPDIR
fi


