#!/bin/bash

# Gathering Facts
ansible webservers -i inventory  -m setup
# Filtering Facts
ansible webservers -i inventory -m setup -a "filter=ansible_distribution"
# Filtering Facts after creating custom ones
ansible webservers -i inventory -m setup -a "filter=ansible_local"
