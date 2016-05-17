#!/usr/bin/env bash

ansible-playbook site.yml \
    -e stack_name="testtoto3" \
    -e api_protocol="http://" \
    -e api_port=8773 \
    -e region_dns=cloud.emea.eucalyptus.com \
    -e template_url=http://objectstorage.cloud.emea.eucalyptus.com:8773/templates/nested.json \
    -e image_id=emi-002fcf91 \
    -e key_name=john \
    -e mgmt_dest_target="80:euca-109-104-120-16.eucalyptus.cloud.emea.eucalyptus.com:8080" \
    -e elb_dest_target="80:demo-dest-elb-000181516251.lb.cloud.emea.eucalyptus.com:80" \
    -e sftp_dest_target="80:demo-dest-elb-000181516251.lb.cloud.emea.eucalyptus.com:80,80:euca-109-104-120-16.eucalyptus.cloud.emea.eucalyptus.com:8080" \
    -e has_elb=True \
    -e has_sftp=True

