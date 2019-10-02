<?php
namespace app\admin\controller;
use app\admin\adminBaseClass;

/**
 * 后台首页控制器
 */
class IndexController extends adminBaseClass{
	public function index($value='')
	{
		// 是否为 青春校园版 ：0为否
		$data['flag'] = 0;
		return view('',$data);
	}
	// 欢迎页面
	public function welcome($value='')
	{
		return view();
	}
	// 待开发页面
	public function develop($value='')
	{
		return "正在开发中";
	}
}