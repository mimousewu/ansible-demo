#!/bin/bash

DAY=`date "+%Y%m%d"`
echo "start plan..."
terraform plan -out plans/$DAY.plan > plans/$DAY.log
cat plans/$DAY.log