#!/bin/bash

CONFIG=/bitnami/opencart/admin/config.php
 
sed -i "s/define('DIR_APPLICATION', '\/opt\/bitnami\/opencart\/admin\/');/define('DIR_APPLICATION', '\/bitnami\/opencart\/admin\/');/"  $CONFIG
sed -i "s/define('DIR_SYSTEM', '\/opt\/bitnami\/opencart\/system\/');/define('DIR_SYSTEM', '\/bitnami\/opencart\/system\/');/"  $CONFIG
sed -i "s/define('DIR_IMAGE', '\/opt\/bitnami\/opencart\/image\/');/define('DIR_IMAGE', '\/bitnami\/opencart\/image\/');/"  $CONFIG
sed -i "s/define('DIR_CATALOG', '\/opt\/bitnami\/opencart\/catalog\/');/define('DIR_CATALOG', '\/bitnami\/opencart\/catalog\/');/"  $CONFIG

