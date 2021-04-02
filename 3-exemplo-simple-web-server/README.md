Para executar o projeto, builde a imagem:

```shell
docker build .
# ou
docker build -t rogerzanelato/simple-web-server .
```

E execute no terminal:
```shell
docker run -p 8080:8080 rogerzanelato/simple-web-server
```

Obs: Precisamos mapear a porta, pois embora nosso container esteja internamente escutando na porta 8080, temos que lembrar que ele é completamente isolado da máquina host, então precisamos conectar a porta 8080 da máquina host, com a porta 8080 do container, se quisermos ser capazes de acessar a API.

Ou utilizando o `docker-compose`:
```shell
docker-compose up
```