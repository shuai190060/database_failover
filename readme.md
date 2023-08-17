# Brief

this repo will contains two small database play-around:

- `postgresql` replication and failover
- `cassandra` sharding
- provision kubernetes cluster with `kubeadm`

## Prerequisite

- run `./inventory.sh` to update the ansible inventory file after `terraform apply`

## Setup for postgresql replication and failover

### Replication setup

- Server: 3 ec2 instances running in the same VPC, but in 2 different availability zone, with two different public subnet
- Network:
    - 22 for ssh
    - 5432 for postgresql communication
- infrastructure is provisioned with terraform by running ``terraform apply``
- postgresql replication is configured by ansible by running ``ansible-playbook -i inventory --vault-id ./.vault_pass.txt database.yml``
    - Remark: the role creation and replication init are not automatic, so additional steps are needed with outputed commands
        - (in master node): enter the postgresql by `su - postgres -c psql`,  `CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD '<password will be provisioned>`';
        - (in slave node): in the user Postgres by doing ``su - postgres``, run output command to sync and replicate the database from master node: ``pg_basebackup -h <master ip address> -D /var/lib/postgresql/12/main -U replicator -v -P -R --wal-method=stream``
    - security remark:
        - for the password, you can overwrite the password, also you can use `ansible-vault` to create a new password variable file to pass it in.
        - the form of the `secret_vars.yml`
         replication_password: <password>

### Failover setup

### setup

- create ssh keys on each nodes and distribute them to other node for ssh communication
- script
    - check if 5432 are on a give IP,
    - promote other slave1 or slave2 as the master node
- start the `keepalived` service

### Command to run

- `ansible-playbook -i inventory --vault-id ./.vault_pass.txt database_failover.yml`

## Kubernetes cluster provision(kubeadm)

### Setup

- at least need `t2.small` instance to run this with 2 cpu cores resources
- security group setup
    - refer to: https://kubernetes.io/docs/reference/networking/ports-and-protocols/

### Command to run

- `./k8s_ec2_provision.sh create / delete`
    - run the command to shift the ec2 and security group creation files
    - `./k8s_ec2_provision.sh create`  to create the resource for k8s
    - `./k8s_ec2_provision.sh delete` to destroy and resume all the files
- `ansible-playbook -i inventory kubeadm.yml`

### other

- pod network add-ons: `calico`