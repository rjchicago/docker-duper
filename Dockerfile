FROM docker

RUN apk add --update --no-cache bash

COPY ./duper.sh /duper.sh

ENTRYPOINT ["sh", "duper.sh"]