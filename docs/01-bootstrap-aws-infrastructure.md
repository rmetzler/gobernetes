# AWS set up infrastructure (EU-Ireland)

## VPC and Internet Gateway
* Create new VPC with IPv4 [CIDR](https://kb.wisc.edu/ns/page.php?id=3493): 10.0.0.0/16 (DNS hostnames: Enabled)
* Create 3 subnets in that VPC (enable auto-assign public IPv4 addresses)
	* 10.0.1.0 gt_sub1
	* 10.0.2.0 gt_sub2
	* 10.0.3.0 gt_sub3
* Create new Internet Gateway and attach it to the VPC
* In VPCs routes add new route (dest=0.0.0.0/0, target=gt_gateway route)

## EC2 instances

* Master - t3.small
* Workers - t2.micro
* CentOS 7
* VPC: gt-vpc, Subnet: sub1 | sub2 | sub3
* Auto-assign Public IP: Enable (way to go without Elastic IPs)
* IAM Role: None, Network Interfaces: eth0 (default)
* Create new Storage Disks: EBS, 10GB, /dev/sdb, General Purpose SSD
* Add name tag for each instance
* Create new Security Group: 
	* TCP; 0 - 65535; 10.0.0.0/16
	* UDP; 0 - 65535; 10.0.0.0/16
	* SSH; 22; 0.0.0.0/0 and ::/0
* Download key-pair used for accessing an instance with SSH
_Repeat steps for all instances, but different subnets_

## Attach new disk storage to be default storage for Docker

* [AWS guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html)
* When you start docker for the first time it will create /var/lib/docker dir
* **If docker already installed:**
* Stop Docker & kubelet if running
* With `lsblk` you can view your available disk device: “<EBS_DISK>”
* Check if `sudo file -s /dev/<EBS_DISK>` output is “data”. If so, there is no file system on that device, so you create on:
	* `sudo mkfs -t xfs /dev/<EBS_DISK>` (use XFS over EXT4)
	* `sudo mv /var/lib/docker /var/lib/docker_old`
	* `sudo mkdir /var/lib/docker`
	* `sudo mount <device_name> /var/lib/docker`
	* Separately on each node: add device to /etc/fstab 
	* umount device and mount -a to check if fstab is working
* `sudo su -`
* `rsync -a /var/lib/docker_old/* /var/lib/docker` 
* `ctrl + D` exit root user
* Reboot instances if Docker and kubelet were stopped
* remove `/var/lib/docker_old/`
* **If docker is not installed already:**
* Before running docker, mkdir `var/lib/docker` 
* `sudo mkfs -t xfs /dev/<DISK>`
* Mount proper device to it
* Add device to /etc/fstab ( **blkid** for getting UUID; defaults, 0, 0)
* `docker info` to check if it’s using proper /var/lib/docker

PS: /var/lib/docker should be monitored, and pruned occasionally; run `docker system df`

- - - -

## AWS ELB set up - optional

* It costs ~ 18USD/month
* Put it in the same VPC as nodes. All 3 subnets enabled.
* Create new SG-LB with inbound ALL TCP (0.0.0.0/0 and ::/0) and outbound all
* Create new listener on port 80 and forward to new Target Group:
	* Register 2 worker nodes and TG instances with NodePort of Nginx Service
	* Add /healthz path for HTTP health check
* ⚠️ Alternative is using only Ingress Controller NodePort + DNS Route53 
* Exposing apps to internet [Bare-metal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/)

## Restart master

* Check if there was an Elastic IP associated with the last one
* If there was a volume attached to instance; when you start it again, docker & kubelet should be started; pods should be recreated automatically.
