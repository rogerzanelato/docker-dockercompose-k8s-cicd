Esse exemplo contempla como seria a configuração de uma imagem docker em React para desenvolvimento e produção.

Quando em desenvolvimento, queremos que atualizações no código fonte, atualizem automáticamente a aplicação (como seria se estivéssemos executando o npm start no local), para isso acontecer, precisamos "linkar" o código fonte do nosso computador com o container, através da flag `-v` de volume.

Além disso, queremos que a bateria de teste também execute em container.

Quando em produção, queremos enviar todo nosso código fonte para o container de forma que ele fique embutido na imagem.

## Executando como dev

Irá rodar a aplicação com o auto-reload funcionando, instalar a aplicação e executar a bateria de teste.

```shell
docker-compose up
```

Infelizmente não irá executar os testes automáticamente, quando uma alteração for efetuada.

## Disclaimers

1. 
A seguinte linha no docker-compose:
volumes:
    - /app/node_modules

Serve para "favoritar" a pasta `node_modules` dentro do container de forma que ela não seja sobrescrita pelo nosso mapeamento da pasta local ao container. Caso essa linha seja removida, o container iria entender que deveríamos usar a pasta `node_modules` do nosso local, e como ela não existe, a aplicação não iria funcionar.

2. 
A seguinte linha foi necessária para o autoreload do container funcionar:
    environment:
      - CHOKIDAR_USEPOLLING=true

3.
A linha `COPY . .` não é necessária no `Dockerfile.dev` porque estamos fazendo o mapeamento da pasta local para o container. O professor do curso prefere deixar a linha lá, mesmo que não tenha uso, como referência.

