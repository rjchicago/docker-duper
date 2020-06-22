FROM docker

RUN apk add --update --no-cache bash

COPY ./src/duper.sh /duper.sh

ENTRYPOINT ["sh", "duper.sh"]