FROM python:3.8-alpine

RUN apk update && apk add bash gcc musl-dev libffi-dev git gpgme-dev libxml2-dev \
        libxslt-dev curl bind-tools --virtual build-dependencies

COPY requirements.txt /tmp/

WORKDIR /ansible

RUN pip install -r /tmp/requirements.txt

COPY . /ansible
