#!/bin/bash
echo "Hello from $1" > /usr/local/apache2/htdocs/index.html
apachectl -DFOREGROUND
