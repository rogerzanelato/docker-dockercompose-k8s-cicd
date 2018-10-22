# Básico para criação de Dockerfile
Resumo e lembretes sobre como criar arquivos dockerfile.

## Links Úteis
- Entrypoint e CMD: https://medium.freecodecamp.org/docker-entrypoint-cmd-dockerfile-best-practices-abc591c30e21
- Copy e ADD: https://medium.freecodecamp.org/dockerfile-copy-vs-add-key-differences-and-best-practices-9570c4592e9e
- Boas Práticas: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

## Comandos

### FROM
Sempre começamos o arquivo do dockerfile com o comando `FROM`, que indica a imagem do sistema operacional que utilizaremos em nossa imagem.
```dockerfile
FROM ubuntu
```

### MAINTAINER
Indica a empresa ou pessoa que é a mantenedora desta imagem.
```dockerfile
FROM Roger Zanelato
```

### RUN
Serve para executar comandos dentro do container assim que ele é criado.
```dockerfile
RUN apt-get-update
```

Podemos ter múltiplos comandos `RUN` no arquivo dockerfile.
```dockerfile
RUN apt-get-update

RUN apt-get-install -y nginx
```

### ENTRYPOINT
É uma outra forma de executar comandos no container através do dockerfile. O entrypoint configura o comando e parâmetros que serão executados primeiramente após o container ser executado (RUN).
Qualquer argumento de linha de comando `docker run <image>` será anexado ao comando entrypoint e **sobrescreverá os elementos especificados no CMD.**
```dockerfile
ENTRYPOINT ["/usr/sbin/nginx"]
```

*Obs: Também poderia ser `ENTRYPOINT ["/usr/sbin/nginx", "param1", "param2"]`.*

### CMD
O propósito do CMD é de providenciar defaults quando estivermos executando o container. Podemos inclusive passar um executável ao CMD:
```dockerfile
CMD ["executable","param1","param2"]
```

Caso o executável seja omitido, é obrigatório que haja um comando ENTRYPOINT no arquivo, os parâmetros definidos serão passados como default ao entrypoint.
```dockerfile
CMD ["start","-g"]
```

**Notas:**
- Pode haver apenas uma instrução CMD por dockerfile, se houver mais de uma apenas a última surtirá efeito. Qualquer argumento de linha de comando `docker run <image>` será anexado ao comando entrypoint e **sobrescreverá os elementos especificados no CMD.**


### ADD
Usado para incluir arquivos numa imagem, sendo: `ADD <source> <destination>` ou `ADD ["<source>", "<destination>"]`.
```dockerfile
ADD ["./configs/nginx.conf" , "/etc/nginx/sites-enabled/default"]
```

**Notas:**
- Se <source> for um arquivo **local** tar em um formato conhecido de compressão, então ele será automaticamente descompactado pelo Docker como um diretório na imagem.
- Se <source> for uma URL, ele irá fazer download do arquivo no destino dentro da imagem do Docker. Porém, os criadores do Docker desencorajam utilizar o ADD com esse propósito.

*Um exemplo de como não utilizar o ADD com URLs remota, seria utilizando o comando RUN e criando a pasta manualmente com um CURL ou WGET.
Exemplo:*
```
RUN mkdir -p /usr/src/things \
    && curl -SL http://example.com/big.tar.xz \
    | tar -xJC /usr/src/things \
    && make -C /usr/src/things all
```

### COPY
O comando `COPY` funciona de forma identica ao `ADD`, tendo apenas menos recurso que ele. O comando COPY não irá descompactar o arquivo caso ele esteja em formato tar, ou tentará baixar caso seja uma URL. [As boas práticas](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy "As boas práticas") de Docker segerem utilizar o COPY, se não houver necessidade especifica do ADD.
```dockerfile
COPY ["./configs/nginx.conf" , "/etc/nginx/sites-enabled/default"]
```

## Criando a Imagem
Após termos criado a imagem, utilizamos o comando `docker build` para criá-la.

```shell
docker build -t rogerzanelato/nginx .
```

Obs: O `.` no final diz para o Docker procurar o arquivo dockerfile neste diretório.

### Flags
- `-t`: Nome da imagem. Ex: rogerzanelato/nginx.