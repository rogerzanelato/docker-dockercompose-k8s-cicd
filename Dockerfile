FROM ubuntu

MAINTAINER Roger Zanelato

RUN apt-get update

RUN apt-get install -y nginx && apt-get clean

ADD ./configs/nginx.conf /etc/nginx/sites-enabled/default

# Direcionar os logs de saída e de erro ao nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Expõe a porta 8080 para escutar requisições de fora
EXPOSE 8080

CMD service nginx start -g