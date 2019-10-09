<?php

namespace app\admin\controller;
use app\admin\adminBaseClass;
use app\model\UsersModel as Users;
use app\model\ManageLogModel as ManageLog;

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
		$page = input('get.page');
		$limit = input('get.limit');

		$data['usersListAll'] = Users::order('created_at desc') -> select();
		$data['usersList'] = Users::order('id asc') -> limit(($page-1)*$limit,$limit) -> select();
		return return_table($data['usersList'],$data['usersListAll']);
	}

	// 用户添加 页面渲染
	public function add()
	{
		return view();
	}

	// 用户修改 页面渲染
	public function edit($id)
	{
		$userRow = Users::get($id);
		return view('',[
			'id' => $id,
			'userRow' => $userRow,
		]);
	}

	// 保存数据
	public function saveData()
	{
		// 接收数据
		$data = input('post.');
		$data['add_user'] = session('manage')['name'];
		$data['created_at'] = time();

		if (empty($data['name']) || empty($data['sex'])) {
			// 信息不全，重新填写
			exit_msg("信息不全，请重新填写");
		}else if (empty($data['pw'])) {
			// 如果密码为空则默认密码为123456
			$data['pw'] = md5(md5("123456"));
		}else{
			if ($data['pw'] == "000000") {
				unset($data['pw']);
			}else{
				$data['pw'] = md5(md5($data['pw']));
			}
		}

		// 处理数据
		$data['name'] = trim($data['name']);
		$data['s_num'] = trim($data['s_num']);
		$data['sex'] = $data['sex']=='男'?'0':'1';
		// halt($data);
		if (isset($data['id'])) {// 说明是编辑状态的数据保存
			$this -> saveEdit($data);
		}else{
			$this -> saveAdd($data);
		}
	}

	// 新增状态的数据保存
	private function saveAdd($data)
	{
		// 处理编号和身份证号
		if ($data['s_num']!='') {
			$user1 = Users::getByS_num($data['s_num']);
			if ($user1) {
				exit_msg("此编号已存在！请重新填写或使用默认编号！");
			}
		}else{
			// 临时编号
			$data['s_num'] = "F9999";
		}
		if (!empty($data['card'])) {
			$user2 = Users::getByCard($data['card']);
			if ($user2) {
				exit_msg("此身份证号已存在！请重新填写或删除身份证号！");
			}
		}

		// 新增记录
		$user = Users::create($data);
		// 获取 SQL 语句
		$sql = Users::getLastSql();
		// 如果是临时编号，那么修改编号为 F 连上 此时的自增id
		if ($data['s_num'] == "F9999") {
			$user -> s_num = "F".complement($user -> id,3);
			$user -> save();
		}
		// 记录操作日志
		ManageLog::log(5,$sql);
		return exit_msg("操作成功！",1);
	}

	// 编辑状态的数据保存
	private function saveEdit($data)
	{
		$userRow = Users::get($data['id']);
		// 处理编号和身份证号
		if ($data['s_num']!='') {
			$user1 = Users::getByS_num($data['s_num']);
			// 用户输入的 s_num 与本条记录的 s_num 不同
			// 并且数据库当中已存在相同的 s_num
			if ($data['s_num'] != $userRow['s_num'] && $user1) {
				exit_msg("此编号已存在！请重新填写或使用默认编号！");
			}
		}else{
			// 使用原先的编号
			$data['s_num'] = $userRow['s_num'];
		}
		if ($data['card'] != '' && $data['card'] != $userRow['card']) {
			$user2 = Users::getByCard($data['card']);
			if ($user2) {
				exit_msg("此身份证号已存在！请重新填写或删除身份证号！");
			}
		}
		// 修改记录
		$user = Users::update($data);
		// 获取 SQL 语句
		$sql = Users::getLastSql();
		// 记录操作日志
		ManageLog::log(1,$sql);
		return exit_msg("操作成功！",1);
	}

	// 删除人员信息
	public function del($id)
	{
		// 删除并获取删除 SQL 语句
		$del = Users::destroy($id);
		if (!$del) {
			exit_msg("删除失败");
		}else{
			$sql = Users::getLastSql();
			ManageLog::log(2,$sql);
			return exit_msg("删除成功！",1);
		}
	}
}