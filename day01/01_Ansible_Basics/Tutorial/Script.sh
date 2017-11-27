#!/bin/bash

# Disalbe HostKey checking at 1st execution
export ANSIBLE_HOST_KEY_CHECKING=False

# Ping localhost mit inventory
ansible all -m ping -i inventory

# Enable HostKey checking again
unset ANSIBLE_HOST_KEY_CHECKING

#Pattern (http://docs.ansible.com/ansible/latest/intro_patterns.html)
ansible nyc -m ping -i inventory

ansible usa:&ffm -m ping -i inventory

ansible all:\!nyc -m ping -i inventory
