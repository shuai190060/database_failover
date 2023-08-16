#!/bin/bash

# clean the inventory file
echo "" > inventory
# Extract values from JSON output
MASTER=$(terraform output -json | jq -r '.master_ip.value')
SLAVE_1=$(terraform output -json | jq -r '.slave_ip_1.value')
SLAVE_2=$(terraform output -json | jq -r '.slave_ip_2.value')


# create master group
echo "[master]" >> inventory
master="manager ansible_host={MASTER} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible"
master=$(echo "$master" | sed "s/{MASTER}/$MASTER/g")
echo $master >> inventory


# create slave group
echo "[slave]" >> inventory

slave_1="slave_1 ansible_host={SLAVE_1} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible"
slave_1=$(echo "$slave_1" | sed "s/{SLAVE_1}/$SLAVE_1/g")
echo $slave_1 >> inventory

slave_2="slave_2 ansible_host={SLAVE_2} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible"
slave_2=$(echo "$slave_2" | sed "s/{SLAVE_2}/$SLAVE_2/g")
echo $slave_2 >> inventory