nat-to-dns
==========

The NAT To DNS (NAT2DNS) system is a combination of Ansible and CloudFormation that solves the tiny old problem to send traffic to a dynamic target which has to be resolved with a DNS name (ie: ELB) but to have a static entry point.

This is a classical topology for private cloud that some of you might face if you use Eucalyptus as your IaaS private cloud solution, behind your corportate firewalls.

The NAT2DNS system was developed in order to match 4 different topologies :
- Unique VM behind FW
- Unique VM behind FW and 1 ELB
- 2 VMs behind FW
- 2 VMs behind FW and 1 ELB

The reason why we always have a single VM is historical but could be removed absolutely and have only 1 ELB. PR wanted :D


Requirements
------------

In your cloud, you have EIPs. Those EIPs are not allocated to any account by default. In order to make a good use of it, you have to allocate those EIPs to the account that will run the NAT2DNS stacks.
I recommend that you have one EIP allocated by public IP (or at least the IPs you have on the other side of the FW) therefore you dont have to change the NAT mapping all the time.


Pre-deployment steps
--------------------

Before you move too quickly, you will have to prepare the environment by creating the required artifacts:
- buckets
- eips config files

The templates bucket
--------------------

The templates bucket will store all the templates that you will find in CFTemplate folder of this repo.
Create the bucket and store the JSON files

```

s3cmd mb s3://templates
s3cmd put CFTemplate/*.json s3://templates/

```

The EIP Global config file
--------------------------

The eips-global.conf file is a core configuration file that will represent at a given point in time the available EIPs that the stack can use. It is stored in a 3rd party bucket that logs and stores all configs through time.
This file is pretty to create at start:

```

s3cmd mb s3://nat2dns
euca-describe-addresses | grep -v \-i | awk '{print $2}' > eips-global.conf
s3cmd put eips-global.conf s3://nat2dns

```

Pre-execution
-------------

Once you have decided how to deploy your NAT2DNS (topology-wise) you will need a few settings before going online :
- region_dns
- api_protocol
- api_port
- image_id
- key_name

The region DNS is the root DNS zone of your cloud. For example, if you have with Eucalyptus your EC2 URL pointing to ec2.mycloud.mydomain.net then your region_dns value will be mycloud.mydomain.net
Also for the API port and protocol, Eucalyptus' defaults are http:// and 8773. If you have changed those values change it accordingly. If you run this against AWS (for some reason ..) then point to AWS API.

The image_id and key_name are for you to use in order to specify which image of the JLB will be running and what ssh keypair to use in order to get connected to your VMs.
In my development, I created an image which has its SSH server listen on port 2223 instead of 22 so I can transit SSH end-to-end without using other ports.


Go live
-------

```

# create the stack

ansible-playbook create-stack.yml -e region_dns=
		 		  -e image_id=
				  -e key_name=
				  -e api_port=
				  -e api_protocol=
				  -e mgmt_dest_target=
				  -e sftp_dest_target=
				  -e elb_dest_target=
				  -e stack_name=
				  [ -e has_elb=
				    -e has_sftp=]


```

```

# delete the stack

ansible-playbook delete-stack.yml -e region_dns=
				  -e api_port=
				  -e api_protocol=
				  -e stack_name=


```

WARNING : NEVER USE the CLOUDFORMATION API to delete the NAT2DNS stack. Let the playbook do it. Otherwise, the eips-global.conf will be altered and only remove EIPs from the list.
