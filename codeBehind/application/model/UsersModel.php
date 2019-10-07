<?php

namespace app\model;
use think\Model;

/**
 * 用户信息数据表的模型
 */
class UsersModel extends Model
{
	// 人员性别处理
	public function getSexAttr($sex)
	{
		return $sex?'女':'男';
	}
	// 人员读出时处理的操作时间
	public function getCreatedAtAttr($time)
	{
		$created_at = date("Y-m-d H:i:s",$time);
		return $created_at;
	}
}