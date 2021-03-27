# Docker and Kubernetes: The Complete Guide

Link: https://github.com/StephenGrider/DockerCasts
Curso: https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide

- Imagem: Arquivo único contendo todas as dependências e configurações necessárias para executar um programa.
- Container: Instância de uma imagem
- Docker client (CLI): Ferramenta para enviar comandos ao Docker Server
- Docker server (Daemon): Ferramente que efetivamente cria imagem, executa containers, etc..

## Como funciona um container

O sistema operacional possuí um Kernel que age como uma API entre os Softwares e o Hardware da máquina, é ele quem controla e distribuí a memória, cpu, acesso ao disco, network, etc... 

Dentro disso, existe duas particularidades do Kernel:
- namespacing: Isola os recursos por processo (ou grupo de process). Exemplo Processos, Usuários, Hostnames, Hard Drive, Network..
- cgroup (Control Group): Limite a quantidade de recurso por processo. Ex: Memória, uso de CPU, HD I/O, Network Bandwidth.

Um container Docker é básicamente um processo ou grupo de processos, que possuem um grupo de recursos exclusivos para ele, isolado do sistema operacional, adquirido através d as tecnologias acima.

### Como o Docker executa no meu computador

Contudo, é importante dizer que o `namespacing` e `cgroup` é um conceito que existe apenas no Linux, não é assim que funciona no Windows. Quando o Docker é instalado no MacOS ou Windows, automáticamente é instalado uma Linux Virtual Machine, que irá atuar como o Kernel do Linux no SO correspondente.
