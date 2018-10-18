# Básico de Docker
Resumo e lembretes sobre como utilizar o Docker.

## Links Úteis
- Instalação: https://docs.docker.com/install/linux/docker-ce/ubuntu/
- Imagens: https://hub.docker.com/
- Documentação: https://docs.docker.com/

## Documentação Rápida
Além da documentação abrangente do site, podemos consultar uma documentação rápida com listagem das funções e parâmetros disponíveis pelo próprio terminal, através da flag `--help`.
Ex:
```shell
docker --help
docker run --help
docker exec --help
```

## Criando Containers
Com o código abaixo, criamos um novo container com a imagem nginx. Caso a mesma não se localize no computador, o Docker tentará instalá-la.
```shell
docker run nginx
```

### Flags
- `-d`: Daemon (detach). Faz com que o Container execute em background. Sem essa flag o container é lançado no modo ativo, e teremos que permanecer com o terminal aberto.
- `-it`: Interativo. O container é criado e já somos direcionados ao bash do mesmo.
- `-p`: Porta (publish list). "Publicamos" a porta de um container para o host, dessa forma, poderemos acessar o conteúdo do container para ela. Ex: -p 8080:80. Mapeamos para que a porta 8080 do container seja direcionada à porta 80 do nginx.
- `-v`: Volume. Podemos criar um volume dentro do container e mapeá-lo para uma pasta em nosso host, podendo assim, facilmente executar o sistema em múltiplos ambientes diferentes. Ex: -v /var/www/html/testes:/usr/share/nginx/html.
- `--name`: Nome do container. Ex: --name meu-container-top.
- `--expose`: Expõe uma porta do container. Ex: --expose=9000.
- `--volumes-from`: Mapeamos o volume de um outro container neste que estamos criando. Ex: --volumes-from webserver06.

Observação: Em produção trabalhamos sempre com o conceito de expor o conteúdo dentro do container através da exposição de alguma porta.

## Executando Comando dentro do Container
Podemos executar funções de terminal dentro do container, utilizando para isso a função `exec` seguido do nome ou id do container e o comando.
Ex: 
```shell
docker exec webserver ls
```

Isso é especialmente quando queremos instalar algum pacote rápido no container, sem ter que refazer a imagem ou instalar uma diferente.

### Flags
- `-it`: Interativo. Com essa Flag podemos tornar o acesso interativo e, por exemplo, acessar o shell dentro do container. Exemplo: `docker exec -it webserver /bin/bash`.

## Criando uma imagem à partir de um container
É muito comum que instalemos novos pacotes ou façamos atualizações em um container que está em execução, para podermos reaproveitar essas alterações, o Docker possuí um comando que permite converter as configurações de um container numa nova imagem.
Ex:
```shell
docker commit webserver nginxdefault:v1
```

Com o cmando acima, criamos uma nova imagem à partir do que está em webserver, chamada de nginxdefault, com a tag v1. Para visualizar, podemos utilizar o comando `docker images`.

### Comandos Rápido
- `docker images`: Lista as imagens instaladas na máquina
- `docker ps`: Lista os containers ativos
- `docker ps -a`: Lista todos os containers
- `docker stop`: Para a execução de um container
- `docker start`: Inicia um Container
- `docker inspect`: Abre as configurações em formato json do container
- `docker rm _nome_ou_id_do_container_`: Exclui o container
- `docker rm -f _nome_ou_id_do_container_`: Pausa o container caso o mesmo esteja ativo e o excluí
- `docker rmi _nome_ou_id_da_imagem_`: Exclui a imagem 

## Informações
É importante lembrar que o Docker irá apenas reunir os principais recursos para que o Container funcione. Por isso, muitos recursos que estamos habituados não estarão presentes no container padrão do docker, a não ser que a imagem especificamente tenha incluído isso.
Por isso, é interessante que criemos ambientes por meio de dockerfiles que se adequem às nossas necessidades ou que criemos uma novo imagem à partir de um container configurado.
**Containers são temporários.** Ao apagar um container, todos os dados inseridos nele serão apagados. Para que isso não ocorra, devemos mapear os volumes para que os sistemas sejam armazenados no host e apenas a infraestrutura esteja armazenada no container.