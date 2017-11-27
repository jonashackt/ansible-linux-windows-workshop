#!/bin/bash

# Ping localhost
ansible all -m ping -i "localhost,"


# Disalbe HostKey checking at 1st execution
export ANSIBLE_HOST_KEY_CHECKING=False

# Ping localhost mit inventory
ansible all -m ping -i inventory

# Enable HostKey checking again
unset ANSIBLE_HOST_KEY_CHECKING

#Pattern
ansible all:!nyc -m ping -i inventory
