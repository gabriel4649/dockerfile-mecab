FROM python:2.7.12-alpine

RUN apk add --no-cache build-base git bash curl file openssl sudo

ENV MECAB_VERSION=0.996
ADD mecab-$MECAB_VERSION.tar.gz /tmp
WORKDIR /tmp/mecab-$MECAB_VERSION
RUN ./configure && \
    make && \
    make check && \
    make install

ENV NEOLODG_VERSION=0.0.5
RUN curl -o /tmp/mecab-ipadic-neologd-$NEOLODG_VERSION.tar.gz "https://codeload.github.com/neologd/mecab-ipadic-neologd/tar.gz/v$NEOLODG_VERSION" && \
    tar xvfz /tmp/mecab-ipadic-neologd-$NEOLODG_VERSION.tar.gz -C /tmp
WORKDIR /tmp/mecab-ipadic-neologd-$NEOLODG_VERSION
RUN yes "yes" | ./bin/install-mecab-ipadic-neologd -n && \
    sed -i -e 's/ipadic/mecab-ipadic-neologd/' /usr/local/etc/mecabrc

WORKDIR /
RUN pip install mecab-python==$MECAB_VERSION && \
    apk del git bash curl file openssl sudo && \
    rm -rf /tmp/*

CMD ["mecab"]