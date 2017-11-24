#!/bin/bash
# Ping localhost
ansible all -m ping -i "localhost,"
# Ping localhost mit inventory
ansible all -m ping -i inventory

#Pattern
ansible all:!nyc -m ping -i inventory
