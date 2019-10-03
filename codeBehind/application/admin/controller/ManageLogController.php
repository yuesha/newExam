<?php

namespace app\admin\controller;
use app\admin\adminBaseClass;
use app\model\ManageLogModel as ManageLog;
/**
 * 管理员日志 控制器
 */
class ManageLogController extends adminBaseClass
{
	// 日志查看 页面渲染
	public function index()
	{
		$manage = session("manage");
		$data['logList'] = ManageLog::where(array('manage_id' => $manage['id'])) -> order('action_time desc') -> select();
		return view('',$data);
	}
}