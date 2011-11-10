<?php

class Jchat_module extends JBaseModule {

	function process() {
		global $current_user;
		$current_user = new CurrentUser();
		$this->data['success'] = 1;
		switch ($_POST['action']) {
			case 'authorize':
				$this->auth();
				break;
			default:
				$this->error('no action #' . $_POST['action']);
				break;
		}
	}

	function error($s) {
		$this->data['error'] = $s;
		$this->data['success'] = 0;
	}

	function auth() {
		global $current_user;
		/* @var $current_user CurrentUser */
		if ($current_user->authorized) {
			$this->data['profile'] = $current_user->getListData();
		} else {
			$this->error('user is not authorized');
			return;
		}
	}

}