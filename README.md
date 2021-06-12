# k8s-vagrant-ubuntu-cluster
Create a local kubernetes cluster using virtualbox

The vagrant file will do the following:

```Provision all local VMs using VirtualBox (os ubuntu )
Make required Ubuntu OS mods for the cluster to function properly.
Patch the OS
Install containerd 
Install k8s control plane 1.21.1
Initialize cluster with calico CIDR 
Join the nodes to the master
Create and copy the SSH key to all machines so you can SSH to any node from the Master. 
Add names & IPs to the local hosts file on each master and node.```

once the cluser is ready copy the file and start accessing the cluster 

scp root@10.0.0.10:/etc/kubernetes/admin.conf ~/.kube/vagrant-config

pradhans0906@Swapnasagar % kubectl get nodes

NAME       STATUS   ROLES                  AGE     VERSION
kmaster    Ready    control-plane,master   7m26s   v1.21.1
kworker1   Ready    <none>                 5m9s    v1.21.1
kworker2   Ready    <none>                 2m33s   v1.21.1

pradhans0906@Swapnasagar % kubectl cluster-info
Kubernetes control plane is running at https://10.0.0.10:6443
CoreDNS is running at https://10.0.0.10:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

