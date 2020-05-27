#!/bin/bash
yourfilenames=`ls ./dataset1/*.txt`
for eachfile in $yourfilenames
do
  glpsol --model model1.mod --data $eachfile
  printf "$eachfile \n\n">>resultmd1.txt
done
