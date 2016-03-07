## Magento docker image 

### Requirements
This docker image expects 2 other linked containers to work .

1. Mysqldb or Mariadb linked as 'db'

2. Memcached linked as 'cache'

### Builing the Image yourself.
Go to your [Magento Account](https://www.magentocommerce.com/products/customer/account/login) to get your MAGE_ID.

At [Account Settings > Downloads Access Token](https://www.magentocommerce.com/products/downloads/token/) you can get / generate your Downloads Access Token.

This is required to download the current Magento 1.9.2.4 and its sample-data-package.

```
$ git clone https://github.com/rayphi/docker-magento.git .
$ docker build -t docker-magento --build-arg MAGE_ID=MAG000000000 --build-arg TOKEN=0000000000000000000000000000000000000000 .
$ docker run -td --name mariadb -e USER=user -e PASS=password  paintedfox/mariadb
$ docker run --name memcached -d -p 11211 sylvainlasnier/memcached
$ docker run -p 80:80 -link mariadb:db --link memcached:cache -td docker-magento 
```

Now visit your public IP in your browser and you will see the installer ready to go.. enter the database password when installer prompts ('password') is the default. 


### Advanced information 

This Image will utilize the environment variables from the linked containers and automatically configure its magento itself.

However during install you may have to enter the database password once which is the only manual work.

Cache will be preconfigured.


### Get into our container 
```
docker ps # to get container-id or container-name
docker exec -i -t <container-id or container-name> bash
```

You can use NSENTER to get into our container
#### https://github.com/jpetazzo/nsenter 


### Need support?

#### http://dockerteam.com


Credits:

Please look at these repositories  for adding more parameters/configuring them 

#### https://github.com/SylvainLasnier/memcached/blob/master/README.md

#### https://github.com/Painted-Fox/docker-mariadb


