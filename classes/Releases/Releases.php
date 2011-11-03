<?php

class Releases extends BaseObjectClass {

	public $id;
	public $loaded = false;
	public $data;
	public $fieldsMap = array(
	    'id' => 'int',
	    'date' => 'int',
	    'update_time' => 'int',
	    'image' => 'string',
	    'title' => 'string',
	    'anons' => 'html',
	    'html' => 'html',
	    'enabled' => 'string',
	    'comment_count' => 'int',
	);

	function __construct($id, $data = false) {
		$this->id = $id;
		if ($data) {
			if ($data == 'empty') {
				$this->loaded = true;
				$this->exists = false;
			}
			$this->load($data);
		}
	}

	function dropCache() {
		News::getInstance()->dropCache($this->id);
		$this->loaded = false;
	}

	function _create($data) {
		$tableName = News::getInstance()->tableName;
		$this->dropCache();
		return parent::_create($data, $tableName);
	}

	function _update($data) {
		$tableName = News::getInstance()->tableName;
		$this->dropCache();
		return parent::_update($data, $tableName);
	}

	function load($data = false) {
		if ($this->loaded)
			return false;
		if (!$data) {
			$query = 'SELECT * FROM `releases` WHERE `id`=' . $this->id;
			$this->data = Database::sql2row($query);
		}else
			$this->data = $data;
		$this->exists = true;
		$this->loaded = true;
	}

	function _show() {
		return $this->getListData();
	}

	function getUrl($redirect = false) {
		$id = $redirect ? $this->getDuplicateId() : $this->id;
		return Config::need('www_path') . '/releases/' . $id;
	}

	function getListData() {
		$out = array(
		    'id' => $this->id,
		    'title' => $this->getTitle(),
		    'anons' => $this->getAnons(),
		    'path' => $this->getUrl(),
		);
		return $out;
	}

	function getTitle() {
		$this->load();
		return $this->data['title'];
	}

	function getAnons() {
		$this->load();
		return $this->data['anons'];
	}

}
