O Dockerfile desse exemplo é um exemplo de configuração do Entrypoint.

Como executar:
```shell
# Builda a imagem
docker build -t rogerzanelato/ping .

# Irá pingar para google.com.br, que é o COMMAND default
docker run rogerzanelato/ping

# Irá pingar para stackoverflow.com, pois fornecemos um COMMAND
docker run rogerzanelato/ping stackoverflow.com
```
