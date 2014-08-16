#! /bin/bash

echo "setting the default installer info for magento"
sed -i "s/<host>localhost/<host>db/g" /var/www/app/etc/config.xml
sed -i "s/<username\/>/<username>user<\/username>/" /var/www/app/etc/config.xml
sed -i "s/<password\/>/<password>password<\/password>/g" /var/www/app/etc/config.xml

echo "Creating the magento database..."

echo "create database magento" | mysql -u "$DB_ENV_USER" --password="$DB_ENV_PASS" -h "$DB_PORT_3306_TCP_ADDR" -P "$DB_PORT_3306_TCP_PORT"

while [ $? -ne 0 ]; do
        echo "create database magento" | mysql -u "$DB_ENV_USER" --password="$DB_ENV_PASS" -h "$DB_PORT_3306_TCP_ADDR" -P "$DB_PORT_3306_TCP_PORT"
        echo "show tables" | mysql -u "$DB_ENV_USER" --password="$DB_ENV_PASS" -h "$DB_PORT_3306_TCP_ADDR" -P "$DB_PORT_3306_TCP_PORT" magento
done

echo "Adding Magento Caching"

 sed -i -e  '/<\/config>/{ r /var/www/app/etc/mage-cache.xml' -e 'd}' /var/www/app/etc/local.xml.template
