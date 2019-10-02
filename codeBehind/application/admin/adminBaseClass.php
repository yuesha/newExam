<?php

namespace app\admin;
use think\Controller;

/**
 * 后台控制器的基类（所有后台控制器必须继承该类）
 */
class adminBaseClass extends Controller
{
	function __construct()
	{
		// 后台所有页面未登录即跳到登录页面
		$isLogin = session('manage')?true:false;
		if (!$isLogin) {
			$this -> error("检测到您未登录，请进行登录操作!","/superLogin.html");
		}
	}
}