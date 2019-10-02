<?php

namespace app\admin\controller;
use app\model\ManageModel as Manage;
use app\model\ManageLogModel as ManageLog;
use think\Controller;
use think\Request;

class LoginController extends Controller{
	// 渲染登录页面
	public function index()
	{
		$isLogin = session("manage")?1:0;
		return view('index',array('isLogin' => $isLogin));
	}
	// 实现登录功能
	public function check()
	{
		// 接收表单数据
		$inData = input('post.data');
		$inData = json_decode($inData,true);
		// 判断用户名密码
		if (!isset($inData['name']) || empty($inData['name'])) {
			exit_msg("用户名不能为空");
		}else if (!isset($inData['pw']) || empty($inData['pw'])) {
			exit_msg("密码不能为空");
		}
		// 获取数据库数据
		$manage = Manage::getByName($inData['name']);
		if (!isset($manage)) {
			exit_msg("此用户名不存在");
		}
		// 密码加密规则
		$en_pw = md5(md5($inData['name'].$inData['pw']));
		if ($en_pw != $manage -> pw) {
			$data['manage_id'] = $manage -> id;
			$data['action_ip'] = Request::instance()->ip();
			$data['action_time'] = time();
			$data['action'] = 4;
			ManageLog::create($data);
			exit_msg("密码错误！请重新输入");
		}
		// 将整个管理员数据存入 session 然后跳转后台
		session("manage",$manage -> toArray());
		$data2['manage_id'] = $manage -> id;
		$data2['action_ip'] = Request::instance()->ip();
		$data2['action_time'] = time();
		$data2['action'] = 1;
		ManageLog::create($data2);

		exit_msg("验证成功！",1);
	}
	// 登出方法
	public function loginout($msg = '登出成功！即将为您返回登录页面。')
	{
		// 记录登出日志
		ManageLog::log(3);
		// 删除 session 记录
		session("manage",null);
		$this -> success($msg,"/superLogin.html");
	}
}