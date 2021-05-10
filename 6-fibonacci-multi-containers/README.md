Essa aplicação é um exemplo de como seria a configuração de uma aplicação multi-containers para desenvolvimento e produção, com CI/CD configurado para o Travis e deployment na AWS.

Nesta aplicação, o Travis será responsável por gerar as imagens durante o procedimento de CD, publicá-las no docker.hub e a AWS apenas irá puxar as imagens, adicionar as variáveis de ambiente, e colocar a aplicação no ar.

A aplicação consiste num formulário simples onde é injetado um índice, e a aplicação retorna o número fibonacci correspondente desse índice. Os índices já visualizados são gravados num banco Postgres, enquanto os valores calculados são gravados em cache com o Redis. O calculo é da sequência Fibonacci é feito por um Worker em Node, que é avisado por pub/sub do próprio Redis.

Obs: No local, o front-end é executado pelo WebServer do Node, em produção, ele é executado em um nginx próprio, separado do nginx que faz proxy-reverso para os demais serviços.

# Como executar

```shell
docker-compose up --build
```
