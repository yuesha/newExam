<?php
namespace app\admin\controller;

class IndexController{
	public function index($value='')
	{
		$data['flag'] = 0;
		return view('',$data);
	}
	public function welcome($value='')
	{
		return view();
	}
	public function develop($value='')
	{
		return "正在开发中";
	}
}