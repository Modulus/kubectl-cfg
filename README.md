# What?
This is a kubectl krew plugin to work with ~/.kube config files without messing with the envrionmentvariable $KUBECONFIG. You can list files in this folder and choose which one to use. Remeber the kubectl cfg use will create a link of ~/.kube/config. So backup this if you have important config in this file!

# To test
1. git clone https://github.com/Modulus/kubectl-cfg.git
2. cd kubectctl-cfg
3. sh deploy.sh

# How to run
```
kubectl cfg list
```

```
kubectl cfg use minikube.conf
```

