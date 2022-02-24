#!/bin/bash

#aws ec2 request-spot-instances --instance-count 1 --type "persistent" --launch-specification file://spot.json --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=frontend}]" | jq

if [ -z "$1" ]; then
  echo -e "\e[1;31mInput is missing\e[0m"
  exit 1
fi

COMPONENT=$1
ENV=$2

if [ ! -z "$ENV" ]; then
  ENV="-${ENV}"
fi

Temp_ID="lt-033d52657b386e840"
Temp_ver=3
ZONE_ID=Z0420516KHPFJFNWORZF

#check if instance is already there
CREATE_INSTANCE(){
   aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}"|jq .Reservations[].Instances[].State.Name | sed 's/"//g' | grep -E 'running|stopped' &>/dev/null
  if [ $? -eq -0 ]; then
     echo -e "\e[1;33mInstance is already there\e[0m"
   else
     aws ec2 run-instances --launch-template LaunchTemplateId=${Temp_ID},Version=${Temp_ver} --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]" "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" |jq
  fi

  sleep 10

  #update the DNS record
  IPADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}"| jq .Reservations[].Instances[].PrivateIpAddress | sed 's/"//g' |grep -v null)

  #sed -e "s/IPADDRESS/${IPADDRESS}/" -e "s/COMPONENT/${COMPONENT}/" record.json >/tmp/record.json
  sed -e "s/IPADDRESS/${IPADDRESS}/" -e "s/COMPONENT/${COMPONENT}/" record.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq
}

if [ "${COMPONENT}" == "all" ]; then
 for comp in frontend$ENV mongodb$ENV catalogue$ENV cart$ENV redis$ENV mysql$ENV dispatch$ENV payment$ENV shipping$ENV user$ENV rabbitmq$ENV  ; do
   COMPONENT=$comp
   CREATE_INSTANCE
   done
  else
    COMPONENT=$COMPONENT$ENV
    CREATE_INSTANCE
fi
#cart$ENV redis$ENV mysql$ENV dispatch$ENV payment$ENV shipping$ENV user$ENV rabbitmq$ENV