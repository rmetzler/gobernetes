## GlusterFS
* Create 2 EC2 instances, same VPC, master’s subnet
	* Add an extra storage /dev/sdb; 5GB
	* Use same SG as K8s nodes
	* `sudo mkfs -t xfs <device>`
	* Mount that disk to /data
* Install GlusterFS of gluster/storage nodes:
	* `yum search gluster`-`yum install centos-release-gluster5.noarch`
	* `yum search glusterfs`-`sudo yum install glusterfs-server.x86_64`
	* Enable/Start glusterd with systemctl
	* Make directory /data/gv0
	* In etc hosts add both gluster servers internal IPs with names
	* `gluster peer probe gluster-02`
	* `sudo gluster volume create gv0 replica 2 gluster-01:/data/gv0 gluster-02:/data/gv0` ⚠️ Do only on one gluster node!
	* `sudo gluster volume start gv0`
	* Add fstab entry for that volume
* Set up GlusterFS on worker nodes:
	* `sudo yum install glusterfs`
	* `yum install glusterfs-fuse.x86_64`
	* `mkdir /data`
	* add gluster nodes in etc hosts file
	* `sudo mount.glusterfs gluster-01:/gv0 /data` [on both worker nodes use the same gluster node as primary; everything will be replicated to second one] - it must be done after each reboot
	* There is a way to tell fstab that there is a backup volume partition: `ferris-k8-glusterfs-01:/gv0 /share glusterfs defaults,backupvolfile-server=ferris-k8-glusterfs-02,_netdev 0 0`  (⚠️ not done)
* Set up K8s:
	* Use [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) for volume type