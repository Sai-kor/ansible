#!/bin/bash

#aws ec2 request-spot-instances --instance-count 1 --type "persistent" --launch-specification file://spot.json --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=frontend}]" | jq
#
Temp_ID="lt-033d52657b386e840"
Temp_ver=3

aws ec2 run-instances --launch-template LaunchTemplateId=${Temp_ID},Version=${Temp_ver}