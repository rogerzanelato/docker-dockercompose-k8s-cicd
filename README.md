# Básico de Docker
Resumo e lembretes sobre como utilizar o Docker.

## Links Úteis
- Instalação: https://docs.docker.com/install/linux/docker-ce/ubuntu/
- Imagens: https://hub.docker.com/

## Criando Containers
Com o código abaixo, criamos um novo container com a imagem nginx. Caso a mesma não se localize no computador, o Docker tentará instalá-la.
```shell
docker run nginx
```

### Flags
- `-d`: Daemon (detach). Faz com que o Container execute em background. Sem essa flag o container é lançado no modo ativo, e teremos que permanecer com o terminal aberto.
- `-it`: Iterativo. O container é criado e já somos direcionados ao bash do mesmo.
- `-p`: Porta (publish list). "Publicamos" a porta de um container para o host, dessa forma, poderemos acessar o conteúdo do co'ntainer para ela. Ex: -p 8080:80. Mapeamos para que a porta 8080 do container seja direcionada à porta 80 do nginx.
- `--name`: Nome do container. Ex: --name meu-container-top.
- `--expose`:  Expõe uma porta do container. Ex: --expose=9000.

Observação: Em produção trabalhamos sempre com o conceito de expor o conteúdo dentro do container através da exposição de alguma porta.

### Comandos Rápido
- `docker images`: Lista as imagens instaladas na máquina
- `docker ps`: Lista os containers ativos
- `docker ps -a`: Lista todos os containers
- `docker stop`: Para a execução de um container
- `docker start`: Inicia um Container
- `docker rm _nome_ou_id_do_container_`: Exclui o container
- `docker rm -f _nome_ou_id_do_container_`: Pausa o container caso o mesmo esteja ativo e o excluí
- `docker rmi _nome_ou_id_da_imagem_`: Exclui a imagem