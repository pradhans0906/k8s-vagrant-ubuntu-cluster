#!/bin/bash

echo "[TASK 1] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[TASK 2] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1

echo "[TASK 3] Enable and Load Kernel modules"
cat >>/etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

echo "[TASK 4] Add Kernel settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null 2>&1

echo "[TASK 5] Install containerd runtime"
wget https://github.com/containerd/containerd/releases/download/v1.5.2/cri-containerd-cni-1.5.2-linux-amd64.tar.gz >/dev/null 2>&1

tar --no-overwrite-dir -C / -xzf cri-containerd-cni-1.5.2-linux-amd64.tar.gz

systemctl daemon-reload
systemctl start containerd
#sudo apt-get install -y containerd
#systemctl restart containerd
#sudo systemctl enable containerd >/dev/null 2>&1

echo "[TASK 6] Add apt repo for kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - >/dev/null 2>&1
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/dev/null 2>&1

echo "[TASK 7] Install Kubernetes components (kubeadm, kubelet and kubectl)"
apt install -y kubeadm kubelet kubectl >/dev/null 2>&1

echo "[TASK 8] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 9] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[TASK 10] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
10.0.0.10   kmaster.example.com     kmaster
10.0.0.11   kworker1.example.com    kworker1
10.0.0.12   kworker2.example.com    kworker2
EOF
