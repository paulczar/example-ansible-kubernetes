# Setup

Create virtualenv:

```
```bash
python3 -m venv virtualenv
```

Activate the venv:

```bash
. virtualenv/bin/activate
```

Install python dependendencies:

```bash
pip3 install -r requirements.txt
```

Tell Ansible to use the virtualenv:

```bash
export ANSIBLE_PYTHON_INTERPRETER=`which python`
```

## Create KIND Cluster

```
kind create cluster --config environment/default/kind_config.yaml
```

## Making  Roles

```
ansible-galaxy init roles/name
```
