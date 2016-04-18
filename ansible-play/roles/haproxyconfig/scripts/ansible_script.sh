#!/usr/bin/env bash
for i in {1..4}; do
    ansible-playbook /var/tmp/MyELBtoDNS/ansible-play/elb.yml -e elb_dns_name=`head -1 /var/tmp/elb.conf` -e ec2_url=`head -1 /var/tmp/ec2.conf`  -e s3_url=`head -1 /var/tmp/s3.conf`
    sleep 14
done
