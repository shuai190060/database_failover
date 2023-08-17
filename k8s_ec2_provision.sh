#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "pass in 'create' or 'delete' as argument"
    exit 1
fi 

case $1 in 
    create)
        mv 3-security_group.tf ./tmp/3-security_group_backup.tf
        mv 4-ec2.tf ./tmp/4-ec2_backup.tf
        cp ./tmp/3-security_group_k8s.tf 3-security_group.tf
        cp ./tmp/4-ec2_k8s.tf 4-ec2.tf

        terraform apply 
        ;;
    
    delete)
        terraform destroy --auto-approve

        mv 3-security_group.tf ./tmp/3-security_group_k8s.tf
        mv 4-ec2.tf ./tmp/4-ec2_k8s.tf
        mv 3-security_group_backup.tf 3-security_group.tf
        mv 4-ec2_backup.tf 4-ec2.tf
        ;;
    
    *)
        echo "Invalid argument, use 'create' or 'delete' as argument "
        exit 1
        ;;

esac

exit 0
