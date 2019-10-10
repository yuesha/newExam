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
function return_table($dataRows,$dataRowsAll,$msg = '',$code = 1)
{
	$arr['code'] = 0;
	$arr['msg'] = $msg;
	$arr['count'] = count($dataRowsAll);
	$arr['data'] = $dataRows;
	return json($arr);
}

// 数字补足所需位数(需要补足的数字，补几个0)
function complement($num,$digit)
{
	return sprintf("%0".$digit."d",$num);
}

// 使用 phpexcel 读取数据
/**
 * $codition 条件数组：文件限制大小、后缀
 * $savePath 保存路径：默认在缓存目录下
 */
function getExcelData($condition = ['size'=>200000,'ext'=>'xlsx,xls,csv'],$savePath = RUNTIME_PATH . DS . 'excelField')
{
	import('PHPExcel.PHPExcel');
	$objPHPExcel = new \PHPExcel();

	//获取表单上传文件
	$file = request()->file('excel');
	$info = $file->validate($condition)->move($savePath);
	if ($info) {
		// 上传文件名
		$fileSaveName = $info->getSaveName();
		//上传文件的地址
		$filePath = $savePath . DS . $fileSaveName;
		$objReader =\PHPExcel_IOFactory::createReader('Excel2007');
		//加载文件内容,编码utf-8
		$obj_PHPExcel =$objReader->load($filePath, $encode = 'utf-8');
		//转换为数组格式
		$excel_array=$obj_PHPExcel->getsheet(0)->toArray();
		// 去掉标题行
		$title_row = array_shift($excel_array);  //删除第一个数组(标题);
		return $excel_array;
	}else{
		exit_msg("上传失败，请检查权限问题！");
	}
}