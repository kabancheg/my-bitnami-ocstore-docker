#!/bin/bash

CONFIG=/bitnami/opencart/config.php
 
sed -i "s/define('DIR_APPLICATION', '\/opt\/bitnami\/opencart\/catalog\/');/define('DIR_APPLICATION', '\/bitnami\/opencart\/catalog\/');/"  $CONFIG
sed -i "s/define('DIR_SYSTEM', '\/opt\/bitnami\/opencart\/system\/');/define('DIR_SYSTEM', '\/bitnami\/opencart\/system\/');/"  $CONFIG
sed -i "s/define('DIR_IMAGE', '\/opt\/bitnami\/opencart\/image\/');/define('DIR_IMAGE', '\/bitnami\/opencart\/image\/');/"  $CONFIG

