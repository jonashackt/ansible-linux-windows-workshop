FROM httpd:latest
COPY ./create_index.sh /
RUN chmod +x /create_index.sh
RUN chown -R 777 /create_index.sh
ENTRYPOINT /create_index.sh $NAME
