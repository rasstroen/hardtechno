<?php

/*
 * Старая база -  в новую базу
 */
ini_set('memory_limit', '1024M');
ini_set('display_errors', 1);
error_reporting(E_ALL);
set_time_limit(0);
include 'config.php';
if (file_exists('localconfig.php'))
	require_once 'localconfig.php';
else
	$local_config = array();

Config::init($local_config);
include 'include.php';

// news
Database::query('TRUNCATE `news`');
$query = 'SELECT * FROM `module_news` WHERE `type`=0';
$news = Database::sql2array($query, 'id');
foreach ($news as $id => $newsitem) {
	$object = News::getInstance()->getById($id);
	/* @var $object Newsitem */
	$data = $newsitem;
	$data['update_time'] = strtotime($data['update_time']);
	$object->_create($data);
}

// releases
Database::query('TRUNCATE `releases`');
$query = 'SELECT * FROM `module_news` WHERE `type`=1';
$news = Database::sql2array($query, 'id');
foreach ($news as $id => $newsitem) {
	$object = Releases::getInstance()->getById($id);
	/* @var $object Newsitem */
	$data = $newsitem;
	$data['update_time'] = strtotime($data['update_time']);
	$object->_create($data);
}
