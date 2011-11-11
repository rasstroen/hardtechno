<?php

class Jchat_module extends JBaseModule {

        public $max_messages = 10;

        function process() {
                global $current_user;
                $current_user = new CurrentUser();
                $this->data['success'] = 1;
                switch ($_POST['action']) {
                        case 'authorize':
                                $this->auth();
                                break;
                        case 'fetch':
                                $this->fetch();
                                break;
                        case 'say':
                                $this->say();
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

        function say() {
                global $current_user;
                /* @var $current_user CurrentUser */
                if (!$current_user->authorized) {
                        $this->error('authorization required');
                }
                $message = trim(strip_tags($_POST['message']));
                if (!$message) {
                        $this->error('illegal message');
                }
                $query = 'INSERT INTO `hard_chat` SET
                        `id_user`=' . $current_user->id . ',
                        `message`=' . Database::escape($message) . ',
                        `time`=' . time();
                Database::query($query);
                $lid = Database::lastInsertId();
                $this->data = $this->getMessages($lid-1, $current_user->id);
                $this->data['last_message_id'] = $lid;
                $this->data['success'] = 1;
                return;
        }

        function getMessages($from_id, $uid) {
                $out = array();
                $messages = Database::sql2array('SELECT * FROM `hard_chat` ORDER BY `id` DESC LIMIT ' . $this->max_messages, 'id');
                $uids = array();
                foreach ($messages as $id => $message) {
                        // if id < requested last message
                        if ($from_id && ($id <= $from_id))
                                unset($messages[$id]);
                        $uids[$message['id_user']] = $message['id_user'];
                }
                $out['messages'] = array_slice($messages, -$this->max_messages);
                $out['users'] = $this->getMessagesUsers($uids);
                return $out;
        }

        function getMessagesUsers($uids) {
                $users = Users::getByIdsLoaded($uids);
                $out = array();
                foreach ($users as $user) {
                        $out[$user->id] = $user->getListData();
                }
                return $out;
        }

        function fetch() {
                global $current_user;
                $last_received_id = max(0, (int) $_POST['last_message_received_id']);
                $last_received_time = max(0, (int) $_POST['last_message_received_time']);
                $this->data = $this->getMessages($last_received_id, $current_user->id);
                $this->data['success'] = 1;
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