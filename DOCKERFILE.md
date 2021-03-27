# Básico para criação de Dockerfile
Resumo e lembretes sobre como criar arquivos dockerfile.

## Links Úteis
- Entrypoint e CMD: https://stackoverflow.com/questions/21553353/what-is-the-difference-between-cmd-and-entrypoint-in-a-dockerfile
- Copy e ADD: https://medium.freecodecamp.org/dockerfile-copy-vs-add-key-differences-and-best-practices-9570c4592e9e
- Boas Práticas: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

## Dica Importante!

Os steps do Dockerfile são cacheados pelo Docker na hora de gerar uma imagem, isso significa que ao gerarmos duas imagens com steps similares, a segunda utilizará o cache ao invés de efetuar a instalação novamente, tornando alterações em Dockerfile bem rápidas de serem executadas.

Exemplo: Supondo que nosso Dockerfile tenha o `RUN apt-get-install -y nginx` em um dos steps, e buildemos a imagem duas vezes `docker build -t rogerzanelato/docker-teste:v1 .` e `docker build -t rogerzanelato/docker-teste:v2`, a v2 será buildada extremamente rápido, devido ao reaproveitamento do cache.

Contudo, há um ponto importante de se lembrar, sempre que uma alteração é feita no Dockerfile, o Docker irá reaproveitar o cache presente **até o ponto exato alterado**. Isso significa que dali pra baixo o cache será inválidado, todos os steps serão reexecutados. Portanto, sempre coloque no Dockerfile os steps mais estáticos na parte superior (ex: instalação da infraestrutura), e deixe os steps que serão mais comumemente alterados (ex: código fonte), na parte inferior.



## Comandos

### FROM
Uma imagem docker é igual à um computador recém comprado com um HD vazio. Ele tem todo o necessário, mas para executar, precisa de um sistema operacional. O `FROM` funciona como o sistema operacional, ele irá dar a base de que essa imagem irá partir, podendo tanto ser literalmente um sistema operacional, ex: `ubuntu`.
Quanto uma mais especilizada, ex: `node` ou `nginx`.

```dockerfile
FROM ubuntu
```

### MAINTAINER
Indica a empresa ou pessoa que é a mantenedora desta imagem.
```dockerfile
FROM Roger Zanelato
```

### WORKDIR
Indica a pasta em que nossas operações serão efetuadas. Caso não seja informado, será utilizado a pasta default da imagem, que pode acabar conflitando com os arquivos da aplicação. Caso a pasta não exista, o workdir irá criá-la dentro da imagem.

```dockerfile
WORKDIR /usr/app
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

### CMD
O CMD define o executável default de nossa imagem. Por exemplo, quando fazemos um `docker run hello-world` o que está sendo exibido no terminal, nada mais é do que o output de um programa executável que existe dentro do terminal.
```dockerfile
CMD ["npm", "start"]
```

O programa default é definido pelo CMD, e pode ser sobrescrito anexando um novo comando ao docker run, exemplo:

```shell
# substituí o comando da imagem node:alpine por "ls" que irá ativar o programa ls dentro do container (que lista as pastas e arquivos do diretório)
docker run node:alpine ls
```

### ENTRYPOINT

Para entender o entrypoint, é preciso entender que o Docker tem um "entrypoint" default que é `/bin/sh -c` que como sabemos, é um comando shell para executar alguma coisa.
Quando executamos `docker run -i -t ubuntu bash` o entrypoint é `/bin/sh -c` a imagem é `ubuntu` e o commando (cmd) é `bash`. **O comando é executado através do entrypoint**, então na instrução acima, o que de fato é executado no container ubuntu é `/bin/sh -c bash`.

Esse é o default do Docker, porém, os usuários pediram para serem capazes de modificar esse default, e então a instrução de Entrypoint foi criada, permitindo usarmos a criatividade para criar imagens diferentes.

Exemplo, poderiamos criar uma imagem para efetuar ping:
```dockerfile
FROM alpine
# Alteramos o entrypoint default do Docker para o executável ping
ENTRYPOINT ["/bin/ping"]
# Dizemos que o default será pingar para o google
CMD ["google.com.br"]
```

E se quisermos pingar para um lugar diferente, apenas alteraríamos o comando:
```dockerfile
docker build -t rogerzanelato/ping .

# Irá pingar para google.com.br
docker run rogerzanelato/ping

# Irá pingar para stackoverflow.com
docker run rogerzanelato/ping stackoverflow.com
```

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
# ou, para copiar tudo de uma pasta à outra
COPY ./ ./
```

## Criando a Imagem
Após termos criado a imagem, utilizamos o comando `docker build` para criá-la.

```shell
docker build -t rogerzanelato/nginx .

# podemos também específicar o Dockerfile
docker build -f Dockerfile.dev .
```

Obs: O `.` no final diz para o Docker procurar o arquivo dockerfile neste diretório.

https://docs.docker.com/engine/reference/commandline/build/

### Flags
- `-t`: Tag da imagem. Ex: rogerzanelato/nginx.
- `-f`: Nome do dockerfile. Ex:  -f Dockerfile.dev