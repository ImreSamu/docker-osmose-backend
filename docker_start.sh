#!/bin/bash
# 
# Deploy the taginfo container
#


set -x
echo "Start ..  "
sudo docker run -it  -v /docker_export:/docker_export  osmose-backend-dev  /bin/bash

