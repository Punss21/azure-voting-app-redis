#!/bin/bash
ping -c3 http://localhost:8000 > /dev/null
if [ $? -eq 0 ]
  then 
    echo ok 
    exit 0
  else
    echo “fail”
fi