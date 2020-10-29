# Setup

## local

> note: to use ansible-playbook directly from the virtualenv you need to set `export ANSIBLE_PYTHON_INTERPRETER=./virtualenv/bin/python`

Create virtualenv:

```bash
make virtualenv
```

### Create KIND Cluster

```
make kind
```

### Deploy

```
make deploy
```

## docker

...

# Making  Roles

```
ansible-galaxy init roles/name
```
