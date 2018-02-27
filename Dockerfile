FROM mongo:3.6.2
LABEL MongoDB in Docker with capability to run as a sharded replicaset

COPY ./entrypoint.sh /usr/local/bin/
COPY ./customized_default_entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh && chmod a+x /usr/local/bin/customized_default_entrypoint.sh && mkdir /mongo-init.d

VOLUME /mongo-init.d

ENTRYPOINT ["entrypoint.sh"]

CMD ["mongod"]