FROM centos:centos6

ARG MAGE_ID

ARG TOKEN

ENV url https://${MAGE_ID}:${TOKEN}@www.magentocommerce.com/products/downloads/file

ENV mageVersion 1.9.2.4

# because theses where the most stable php 5.3.x repos are!

MAINTAINER r@tweitmann.com

# Centos default image for some reason does not have tools like Wget/Tar/etc so lets add them
RUN yum -y install wget

# EPEL has good RPM goodies!
RUN rpm -Uvh   http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

RUN yum -y install which openssh-server php-mysql php-gd php-mcrypt php-mbstring php-zip php-xml php-iconv php-curl php-soap php-simplexml php-pdo php-dom php-cli php-fpm nginx

RUN yum -y install tar mysql

ADD default.conf /etc/nginx/conf.d/default.conf

RUN chkconfig php-fpm on

RUN chkconfig nginx on

#install magento files 

RUN cd /tmp && curl -O ${url}/magento-${mageVersion}.tar.gz && curl -O ${url}/magento-sample-data-1.9.1.0.tar.gz

RUN cd /tmp && tar -zxvf magento-${mageVersion}.tar.gz && tar -zxvf magento-sample-data-1.9.1.0.tar.gz

RUN mv /tmp/magento /var/www

RUN cp -R /tmp/magento-sample-data-1.9.1.0/media/* /var/www/media/ && cp -R /tmp/magento-sample-data-1.9.1.0/skin/* /var/www/skin/

RUN rm -rf /tmp/magento-sample-data-1.9.1.0/media /tmp/magento-sample-data-1.9.1.0/skin /tmp magento-*.tar.gz

RUN cd /var/www/ && chmod -R o+w media var && chmod o+w app/etc && chown apache .

ADD mage-cache.xml /var/www/app/etc/mage-cache.xml

ADD seturl.php /var/www/seturl.php

ADD start.sh /start.sh

RUN chmod 0755 /start.sh 

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

CMD /start.sh


