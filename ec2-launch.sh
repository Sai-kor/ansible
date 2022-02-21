#!/bin/bash

#aws ec2 request-spot-instances --instance-count 1 --type "persistent" --launch-specification file://spot.json --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=frontend}]" | jq

if [ -z "$1" ]; then
  echo -e "\e[1;31mInput is missing\e[0m"
  exit 1
fi

COMPONENT=$1

Temp_ID="lt-033d52657b386e840"
Temp_ver=3
#check if instance is already there

 aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}"|jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E 'running|stopped' &>/dev/null
if [ $? -eq -0 ]; then
   echo -e "\e[1;33mInstance is already there\e[0m"
 exit
fi

aws ec2 run-instances --launch-template LaunchTemplateId=${Temp_ID},Version=${Temp_ver} --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" |jq

#update the DNS record
