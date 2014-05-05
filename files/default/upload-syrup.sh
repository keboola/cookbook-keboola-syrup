#!/usr/bin/sh
timestamp=`date +%s`
echo $timestamp
tar -zcvf /tmp/syrup-latest.tar.gz /www/syrup-router/
aws s3 cp /tmp/syrup-latest.tar.gz s3://syrup-releases/syrup-latest.tar.gz
aws s3 cp /tmp/syrup-latest.tar.gz s3://syrup-releases/syrup-$timestamp.tar.gz