Front-end da aplicação fibonacci-multi-containers.

Comandos:
```bash
# Cria os containers
kubectl apply -f client-pod.yaml
kubectl apply -f client-node-port.yaml
```

Após executar os comandos acima, basta acessar no navegador `localhost:31515`.

Podemos também verificar o status dos pods/services pelo terminal:

```bash
# Lista os pods
kubectl get pods

# Lista os services
kubectl get services

# Lista todos
kubectl get all
```

Ex:
```bash
$ kubectl get all
NAME             READY   STATUS    RESTARTS   AGE
pod/client-pod   1/1     Running   2          11m

NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/client-node-port   NodePort    10.100.207.137   <none>        3050:31515/TCP   11m
service/kubernetes         ClusterIP   10.96.0.1        <none>        443/TCP          24d
