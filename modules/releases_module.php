<?php

class releases_module extends CommonModule {

	function setCollectionClass() {
		$this->Collection = Releases::getInstance();
	}

	function _process($action, $mode) {
		switch ($action) {
			case 'list':
				switch ($mode) {
					default:
						$this->_listDefault();
						break;
				}
				break;
			default:
				throw new Exception('no action #' . $action . ' releases_module');
				break;
		}
	}

	function _listDefault() {
		$where = '`enabled`=1';
		$sortings = array(
		    'date' => array('date' => 'по дате добавления', 'order' => 'desc'),
		);
		$data = $this->_list($where, array(), false, $sortings);
		if (isset($this->data['releases'])) {
			foreach ($this->data['releases'] as &$item) {
				$item['path_edit'] = 'releases/' . $item['id'] . '/edit';
				$item['path_delete'] = 'releases/' . $item['id'] . '/delete';
			}
			$this->data['releases']['title'] = 'Релизы';
			$this->data['releases']['count'] = $this->getCountBySQL($where);
		}
	}

}