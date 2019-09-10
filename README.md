# What?
This is a kubectl krew plugin to work with ~/.kube config files without messing with the envrionment variable $KUBECONFIG. You can list files in this folder and choose which one to use. Remeber the kubectl cfg use will create a link of ~/.kube/config. So backup this if you have important config in this file!

# To test
1. Download zip file
2. kubectl krew install --manifest=config-file.yaml --archive=kubectl-config-file-0.0.7.zip

# How to run
```
kubectl config-file list
```

```
kubectl config-file use minikube.conf
```

