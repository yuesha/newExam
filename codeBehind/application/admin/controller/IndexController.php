<?php
namespace app\admin\controller;
use app\admin\adminBaseClass;
use app\model\UsersModel as Users;
use app\model\QuestionsModel as Questions;
use app\model\ExamModel as Exam;
// use think\Cache;

/**
 * 后台首页控制器
 */
class IndexController extends adminBaseClass{
	public function index()
	{
		// 是否为 青春校园版 ：0为否
		$data['flag'] = 0;
		return view('',$data);
	}
	// 欢迎页面
	public function welcome()
	{
		// 统计 注册用户数量 、 导入试题数量 信息
		$data['userCount'] = Users::count();
		$data['questionsCount'] = Questions::count();
		$data['examCount'] = Exam::count();
		$data['manage'] = session('manage');
		$data['server'] = input('server.');
		return view('',$data);
	}
	// 待开发页面
	public function develop()
	{
		return "正在开发中";
	}
}