# Brief

this repo will contains two small database play-around:

- postgresql replication and failover
- cassandra sharding

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

### Failover setup