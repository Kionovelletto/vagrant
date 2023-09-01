#!/bin/bash

# PARA INICIAR AS VM EXECUTE: vagrant up
# PARA ENCERRAR AS VM EXECUTE: vagrant halt
# PARA REMOVER AS VMS EXECUTE: vagrant destroy postgresql15-db01 ; vagrant destroy postgresql15-db02

sudo apt-get update
sudo apt-get install -y postgresql-15

echo "host    replication     all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/15/main/pg_hba.conf
echo "wal_level = replica" | sudo tee -a /etc/postgresql/15/main/postgresql.conf
echo "max_wal_senders = 2" | sudo tee -a /etc/postgresql/15/main/postgresql.conf
echo "wal_keep_segments = 32" | sudo tee -a /etc/postgresql/15/main/postgresql.conf

sudo systemctl restart postgresql

sudo -u postgres psql -c "CREATE USER replication REPLICATION LOGIN CONNECTION LIMIT 1 ENCRYPTED PASSWORD 'kio_901_OP';"
sudo -u postgres psql -c "SELECT pg_create_physical_replication_slot('replication_slot');"

sudo ufw allow 5432/tcp

sudo systemctl restart postgresql
