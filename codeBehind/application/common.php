<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件

// 返回 JSON 字符串（code = 0 表示异常）
function exit_msg($msg='',$code='0')
{
	$json = json_encode(array('code' => $code,'msg' => $msg));
	exit($json);
}

// 返回 layui-table 格式的数据
function return_table($dataRows,$msg = '',$code = 1)
{
	$arr['code'] = 0;
	$arr['msg'] = $msg;
	$arr['count'] = count($dataRows);
	$arr['data'] = $dataRows;
	return json($arr);
}