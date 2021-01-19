#!/bin/bash
# fixed from https://github.com/raymondkiu/blastoutput2gff

if [ $# -lt 1 ] ; then
    echo ""
    echo "usage: blastoutput2gff.sh FILENAME"
    echo "convert blast output (tabular format 6) to gff format"
    echo ""
    exit 0
fi

filear=${@};
for i in ${filear[@]}

do

awk '{print $2"\tblast\tgene\t"$9"\t"$10"\t.\t.\t.\tID=Gene"$9";Name="$1}' $i > $i.gff

done