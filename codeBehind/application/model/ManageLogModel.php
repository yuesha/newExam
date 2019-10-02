<?php

namespace app\model;
use think\Model;
use think\Request;
/**
 * 管理员日志信息数据表的模型
 */
class ManageLogModel extends Model
{
	// 日志读出时处理的操作名称
	public function getActionAttr($value)
	{
		$action = [
			0 => '登录成功',
			1 => '更新操作',
			2 => '删除操作',
			3 => '登出成功',
			4 => '尝试登录，密码错误',
		];
		return $action[$value];
	}
	// 日志读出时处理的操作时间
	public function getActionTimeAttr($value)
	{
		$action_time = date("Y-m-d H:i:s",$value);
		return $action_time;
	}
	// 后台记录日志方法（必须先登录）
	public static function log($level = 0,$sql = null)
	{
		$manageInfo = session("manage");
		$ip = Request::instance() -> ip();
		$data['manage_id'] = $manageInfo['id'];
		$data['action_ip'] = $ip;
		$data['action'] = $level;
		$data['action_time'] = time();
		$data['last_sql'] = $sql;
		ManageLogModel::create($data);
	}
}