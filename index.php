<?php
phpinfo();

$u=null;
$u->aaaa = 5;

error_log("bloublou", 0);
error_reporting(E_ALL);

error_log("bloublou2", 0);
$u=null;
$u->aaaa = 5;