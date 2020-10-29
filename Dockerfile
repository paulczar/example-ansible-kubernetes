#
# BUILD
#
FROM python:3.8-alpine as build

# install build prereqs
RUN apk update && apk add bash gcc musl-dev libffi-dev git gpgme-dev libxml2-dev libxslt-dev curl bind-tools --virtual build-dependencies

# add other executables
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.18.3/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

RUN addgroup --system ansible --gid 1000 && adduser --system --shell /bin/bash --ingroup ansible --uid 1000 ansible --home=/ansible
RUN mkdir -p /ansible-virtualenv && chown -R ansible:ansible /ansible-virtualenv
USER ansible:ansible

COPY ./requirements.txt /ansible/requirements.txt

RUN python3 -m venv /ansible-virtualenv
RUN /ansible-virtualenv/bin/python3 -m pip install --upgrade pip
RUN . /ansible-virtualenv/bin/activate
RUN pip3 install -r /ansible/requirements.txt

COPY . /ansible


FROM python:3.8-alpine

# update the image
RUN apk update && apk add bash bind-tools openssl --no-cache

RUN addgroup --system ansible --gid 1000 && adduser --system --shell /bin/bash --ingroup ansible --uid 1000 ansible --home=/ansible

# copy executables from build image
COPY --from=build /usr/local/bin /usr/local/bin

COPY --chown=ansible:ansible . /ansible
COPY --chown=ansible:ansible --from=build /ansible-virtualenv /ansible-virtualenv

USER ansible:ansible

# set pathing
ENV PATH=/ansible-virtualenv/bin:$PATH
ENV PYTHONPATH=/ansible-virtualenv/lib/python3.8/site-packages/
ENV ANSIBLE_PYTHON_INTERPRETER=/ansible-virtualenv/bin/python

# set kubeconfig and ansible options
ENV KUBECONFIG=/ansible/build/.kube/config
ENV ANSIBLE_FORCE_COLOR=1

WORKDIR /ansible
