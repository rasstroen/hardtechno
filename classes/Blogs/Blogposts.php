<?php

class Blogposts extends Collection {

	public $className = 'Newsitem';
	public $tableName = 'news';
	public $itemName = 'newsitem';
	public $itemsName = 'news';

	public static function getInstance() {
		if (!self::$blogs_instance) {
			self::$blogs_instance = new Blogposts();
		}
		return self::$blogs_instance;
	}

	public function _create($data) {
		$item = new $this->className(0);
		$createdId = $item->_create($data);
		header('Location:' . Config::need('www_path') . '/blog/' . $createdId);
		exit();
	}

}