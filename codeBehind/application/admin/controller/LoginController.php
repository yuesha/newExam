<?php

namespace app\admin\controller;
use app\model\ManageModel as Manage;

class LoginController{
	public function index()
	{
		return view();
	}
	// 检查用户名密码
	public function check()
	{
		$data = input('post.data');
		$data = json_decode($data,true);
		if (!isset($data['name']) || empty($data['name'])) {
			exit_msg("用户名不能为空");
		}else if (!isset($data['pw']) || empty($data['pw'])) {
			exit_msg("密码不能为空");
		}
		$manage = Manage::getByName($data['name']);
		return $manage;
		if (!isset($manage)) {
			exit_msg("此用户名不存在");
		}
		// 密码加密规则
		$en_pw = md5(md5($data['name'].$data['pw']));
		if ($en_pw != $manage -> pw) {
			exit_msg("密码错误！请重新输入");
		}
		exit_msg($manage -> created_at);
	}
}