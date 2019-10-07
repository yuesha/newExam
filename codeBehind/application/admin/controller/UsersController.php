<?php

namespace app\admin\controller;
use app\admin\adminBaseClass;
use app\model\UsersModel as User;
/**
 * 用户管理 控制器
 */
class UsersController extends adminBaseClass
{
	// 用户列表查看 页面渲染
	public function index()
	{
		return view('');
	}

	// layui-table 的数据接口
	public function user_list()
	{
		$data['usersList'] = User::order('created_at desc') -> select();
		return return_table($data['usersList']);
	}
}