# MongoDB #

This image is based on the official Mongodb Docker-Image but offers capabilities
to add more configuration via shell scripts. 
These scripts have to be mounted into Containers /mongo-init.d and will be executed sequencially

## How to use ##

To start a container just run ``docker run -d -p 27017:27017 paco0512/mongodb``. 
To start a MongoDB with auth do ``docker run -d -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=<secret-pass> -p 27017:27017 paco0512/mongodb`` this creates a user in the admin DB. 

## Provisioning ##

To provision MongoDB the images exposes two volumes ``/docker-entrypoint-initdb.d`` and ``/mongo-init.d``
In both you can put either .js or .sh scripts.

### Database ###

To create new databases or users you can extend the image putting scripts into ``/docker-entrypoint-initdb.d``.

### MongoDB ###

To configure e.g. a sharded MongoDB cluster you have to run several commands. [This](https://dzone.com/articles/composing-a-sharded-mongodb-on-docker) tutorial by Dzone was a reference implementation. To automate these steps just create scripts and mount it into ``/mongo-init.d``. These scripts will be executed after your Database has been provisioned with all basic stuff like users/ databases.  
