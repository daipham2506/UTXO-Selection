#!/bin/bash
yourfilenames=`ls ./dataset1/*.txt`
for eachfile in $yourfilenames
do
  glpsol --model model2.mod --data $eachfile
  printf "$eachfile \n\n">>resultmodel2_5.txt

done
