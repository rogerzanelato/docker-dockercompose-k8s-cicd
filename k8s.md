# Kubernetes

O Kubernetes é uma ferramenta para automatizar deploys, escalar e gerenciar aplicações em multiplos container, possuíndo uma suíte de ferramentas que facilitam o trabalho no dia-a-dia e a manutenção de nossa aplicação.

**Alguns exemplos:**
- Rollout progressivo com teste blue/green e rollback em caso de erro
- Self-healing
- Escalar horizontalmente
- Service Discovery e Load Balancer
- Gerenciamento de secrets e configurações
- Cron

https://kubernetes.io/

## Porque utilizá-lo?

O K8S brilha e muitas vezes se torna indispensável, quando temos uma aplicação que roda em múltiplos containers. Usando como exemplo o projeto `6-fibonacci`, a aplicação é composta por 4 containers: nginx, client, server e worker.

Caso nossa aplicação precise escalar para dar conta do tráfego, nós como desenvolvedores, sabemos que o único container que precisa escalar para aumentar o processamento, seria o worker. Porém, o scale do Elastic BeanStalk iria escalar os 4 containers em uma nova aplicação separada, e usar um load-balancer para redirecionar o tráfego entre elas.

Com o Kubernetes não precisamos ter esse custo desnecessário, podemos fazer o scale apenas do container que queremos e ele escalará apenas esse container, e fará o redirecionamento do tráfego automáticamente.

**Elastic Beanstalk vs Kubernetes**
ELB:
![](https://i.imgur.com/rm9wTpH.png)

K&S:
![](https://i.imgur.com/7mElLzj.png)

## Formatos de gerenciamento

O nó "master" é o nó responsável por manter o estado do cluster, nós utilizamos o Kubectl para "conversar" com ele. Quando utilizamos o serviço de Kubernetes gerenciado fornecido por um provedor cloud, esse serviço fica responsável por gerenciar o nó master por nós e garantir que nosso cluster está saudável. Quando utilizamos uma versão `self-hosted` ou `self-managed`, nós somos responsável por fazer esse gerenciamento.

Exemplos de serviços gerenciados:
- GKS: Google Kubernetes Engine
- AKS: Azure Kubernetes Service
- EKS: Amazon Elastic Container Service for Kubernetes

https://www.magalix.com/blog/provider-managed-vs.-self-managed-kubernetes

## Kubernetes vs Docker-compose

Embora as funcionalidades sejam parecidas, o K8S é mais poderoso, mais versátil e bem diferente em termos de configuração.

Exemplo de algumas das diferenças entre o processo de criar um container entre os dois:
![](https://i.imgur.com/hWEKkXk.png)

## Kubernetes vs Docker

Como vimos acima, o K8S é uma ferramenta para gerenciar containers, enquanto o Docker é uma ferramenta para executar aplicações em container. Ambas ferramentas não são acopladas, mas se complementam perfeitamente, por isso que é comum utilizá-las em conjunto.

## CLI

Utilizamos o cli `kubectl` para gerenciar nosso cluster.

- `kubectl cluster-info`: Retorna as informações do cluster.
- `kubectl apply -f minha-config.yaml`: Injeta uma configuração no K8S para que algo seja criado (pod, serviço, replica, etc...)
- `kubectl get pods`: Lista os pods no cluster
  - Coluna `READY`:  Indica quantos pod estão prontos de quantos precisamos, ex: 0/1, 1/1, 1/2... 
  - Coluna `STATUS`: Indica o status do pod
- `kubectl get services`: Lista os services no cluster
- `kubectl get all`: Lista todos os tipos de objetos no cluster
- `kubectl describe pod nome-do-meu-pod`: Lista informações sobre o pod, como por exemplo, a imagem de container que ele está usando
- `kubectl describe service nome-da-minha-service`: Lista informações sobre a service
- `kubectl diff -f minha-config.yaml`: Faz um diff entre a configuração atualmente existente no cluster e a atual para esse objeto, permitindo que tenhamos uma "prévia" do que mudou e do que será feito caso apliquemos esse arquivo.

## Configurações

- `apiVersion`: Cada versão de API nos dá acesso à um conjunto diferente de "objetos" que podemos utilizar.

## Object Types

Os arquivos de configuração `yaml` são usados para criar objetos, que são definidos através da tag `kind`.

Cada tipo de objeto possuí um papel específico dentro do cluster, sendo alguns deles:

### StatefulSet e Deployment
```yaml
kind: StatefulSet
# ou
kind: Deployment
```

Ambos tipos de serviço são responsávels por gerenciar Pods, porém, o `Deployment` é mais adequado para aplicações stateless (que não precisam guardar estado) como Apache, Nginx, e outros WebServer.

Para serviços do tipo `Deployment`, os Pods são intercambiáveis, um Pod pode à qualquer momento ser substituído por outro igual.

O `StatefulSet` por outro lado, trata cada Pod como único e armazena uma identidade única para cad Pod que ele gerencia. Dessa forma, ele usa a mesma identidade sempre que é necessário, portanto, ele é mais adequado para aplicações que precisam armazenar estado, como por exemplo, um Cluster ElasticSearch que precisa dos IPs dos nós para comunicar entre si.

Por natureza, um `StatefulSet` precisa de uma ferramente de Storage para poder armazenar seu estado entre reinicializações; o K8S providencia abstrações encima dos mecanismos de storage de clouds providers.

https://www.magalix.com/blog/kubernetes-statefulsets-101-state-of-the-pods

### ReplicaController
```yaml
kind: ReplicaController
```

### Pod
```yaml
apiVersion: v1
kind: Pod
```

Pod é básicamente uma unidade de serviço, uma aplicação. O caso de uso mais comum no K8S é utilizar um Pod por container (one-container-per-pod), porém, há aplicações que rodam em múltiplos containers **altamente acoplados**, onde não faria sentido um existir sem o outro. É comum nesses casos configurar para que o Pod haja múltiplos container.

Quando o Pod possuí múltiplos containers, os containers podem compartilhar recursos entre si, filesystem, dependências, se comunicarem e ainda coordenadar quando e como eles são finalizados.

Pods são isolados entre si, da mesma forma que um container é isolado de outro.

Outra forma de denominar pod é como "a menor unidade possível de serviço deployable".

https://kubernetes.io/docs/concepts/workloads/pods/

### Service
```yaml
kind: Service
spec:
  type: NodePort # ou ClusterIP, ou LoadBalancer, ou Ingress
```
 
Utilizados para configurar a rede em um cluster de K8S.

Podem ser do sub-tipo:
- `ClusterIP`:
- `NodePort`: Expõe nosso container para o exterior (apenas para desenvolvimento local, não deve ser usado em produção a não ser em exceções)
- `LoadBalancer`:
- `Ingress`:

https://medium.com/@chkrishna/kubernetes-objects-e0a8b93b5cdc

#### NodePort

```yaml
kind: Service
spec:
  type: NodePort
  ports:
    - port: 3050
      targetPort: 3000
      nodePort: 31515
  selector:
    component: web
```

![](https://i.imgur.com/t07CTND.png)

`port`: Indica a porta que iremos liberar para que outro `pod` se comunique com este.
`targetPort`: Indica a porta que iremos acessar no `pod` selecionado
`nodePort`: Indica a porta que usaremos para conectar nesse serviço (por isso ele não faz sentido fora do desenvolvimento local, ninguém quer acessar google.com:31515).

`selector`: É uma forma de selecionar um objeto configurado no k8s, o formato de seleção é feito por meio do metadado `labels`. No exemplo acima, estamos selecionado um objeto configurado da seguinte forma:
```yaml
metadata:
  name: client-Pod
  labels:
    component: web
```

O nome `component` é arbitrário, poderíamos por exemplo chamá-lo de `tier` ou qualquer outra coisa, mas teríamos que mudar nos dois yaml.

## Imperative vs Declarative deployments

![](https://i.imgur.com/q3pz88m.png)

Básicamente quando falamos de deploy **Imperativo**, estamos falando de realizar uma série de análise e instruções "manuais" para que nosso cluster chegue no estado desejado através de comandos cli. O deploy **Declarativo** por sua vez é muito mais simples, não precisamos analisar o estado atual do nosso cluster nem efetuar operações diretamente, tudo que iremos fazer é alterar um arquivo de configuração, dizendo qual o estado que desejamos, e o próprio k8s irá ser responsável em fazer o que for necessário, da melhor forma possível, para que o cluster chegue nesse estado ideal.

É importante ressaltar essa diferença, pois o k8s nos permite trabalhar com os dois formatos, mas por razões óbvias, em qualquer carga de trabalho profissional queremos sempre seguir com o formato **Declarativo**, portanto quando lermos blogs, respostas, ou recebermos de ajuda, devemos ter cuidado com instruções do tipo "rode no terminal o comando A/B/C", pois podemos estar fazendo algo no formato mais difícil.

Num fluxo profissional, iremos alterar o estado do k8s aplicando uma configuração atualizada (`kubectl apply -f minha-config.yaml`), e então deixaremos à cargo do k8s converter o cluster para esse estado.

**Observação:**
Jamais devemos mexer em um nó ou pod diretamente (por exemplo, atraves de comandos usando o cli do docker). Como administradores de um cluster k8s, devemos sempre efetuar operações através da cli `kubectl`, e por fim, quem será responsável por gerenciar os nós da melhor forma possível, deverá ser **sempre o k8s**.