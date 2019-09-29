/*
 Navicat Premium Data Transfer

 Source Server         : 4-虚拟机
 Source Server Type    : MySQL
 Source Server Version : 50645
 Source Host           : 192.168.13.4:3306
 Source Schema         : FullExam

 Target Server Type    : MySQL
 Target Server Version : 50645
 File Encoding         : 65001

 Date: 29/09/2019 10:42:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for exam
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `pattern_tag` int(1) NOT NULL COMMENT '应用系统模式:\r\n默认:1:便捷企业版 \r\n2：青春校园版\r\n（不同的系统模式采用不同的菜单）\r\n',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '全自主考试' COMMENT '本次考试名称',
  `organizer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '承办单位',
  `bg_color` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#1e9fff' COMMENT '网站背景颜色',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '网站说明信息',
  `icp` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备案号',
  `switch` int(1) NULL DEFAULT NULL COMMENT '网站运行状态设置：\r\n默认:0:正常运行\r\n1:维护中',
  `draw_the_order` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出题顺序（json 字符串）',
  `topic_distribution` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '题型分布',
  `exam_time` int(3) NULL DEFAULT NULL COMMENT '考试时长',
  `examinee_initial_status` int(1) NULL DEFAULT NULL COMMENT '人员分配标识位:\r\n默认:0:未分配考生\r\n1:已无序分配考生',
  `question_initial_status` int(1) NULL DEFAULT NULL COMMENT '试题初始标识位：\r\n0：未初始试题\r\n1：已按照指定出题顺序初始试题\r\n2：已自由初始试题',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for exam_grade
-- ----------------------------
DROP TABLE IF EXISTS `exam_grade`;
CREATE TABLE `exam_grade`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `user_id` int(11) NOT NULL COMMENT '人员编号：同users表id',
  `type` int(1) NOT NULL COMMENT '题型编号：99:总分\r\n非99:同questions表type_tag\r\n',
  `grade` int(3) NOT NULL DEFAULT 0 COMMENT '分数汇总',
  `section_id` int(11) UNSIGNED ZEROFILL NULL DEFAULT 00000000000 COMMENT '人员隶属分类：默认:0\r\n非0:同section表id\r\n',
  `user_type_id` int(11) NULL DEFAULT 0 COMMENT '人员所属分类：\r\n默认:0\r\n非0:同user_type表id',
  `remark` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '备注信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  CONSTRAINT `exam_grade_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for exam_options
-- ----------------------------
DROP TABLE IF EXISTS `exam_options`;
CREATE TABLE `exam_options`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `exam_user_id` int(11) NOT NULL COMMENT '考试人员id:同exam_user表id',
  `show_order` int(3) NOT NULL COMMENT '试题显示序号',
  `option` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '选项编号',
  `option_value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '选项内容',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exam_user_id`(`exam_user_id`) USING BTREE,
  INDEX `show_order`(`show_order`) USING BTREE,
  CONSTRAINT `exam_options_ibfk_1` FOREIGN KEY (`exam_user_id`) REFERENCES `exam_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `exam_options_ibfk_2` FOREIGN KEY (`show_order`) REFERENCES `exam_questions` (`show_order`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for exam_questions
-- ----------------------------
DROP TABLE IF EXISTS `exam_questions`;
CREATE TABLE `exam_questions`  (
  `id` int(11) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `exam_user_id` int(11) NOT NULL COMMENT '考试人员id：同exam_user表id',
  `show_order` int(3) NOT NULL COMMENT '试题显示序号',
  `type_tag` int(1) NOT NULL COMMENT '试题类型：\r\n0:判断正误题\r\n1:单选题\r\n2:多选题\r\n3:填空题\r\n4:不定项选择题',
  `topic` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '题目（包括括号）',
  `max_score` int(2) NOT NULL COMMENT '分值',
  `true_answer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '正确答案',
  `warehouse_id` int(11) NULL DEFAULT 0 COMMENT '隶属试题库：\r\n默认:0:暂未分配到试题库\r\n非零:同question_warehouse表id',
  `user_answer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '考生作答',
  `tag` int(1) NULL DEFAULT NULL COMMENT '标识位',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `exam_user_id`(`exam_user_id`) USING BTREE,
  INDEX `show_order`(`show_order`) USING BTREE,
  CONSTRAINT `exam_questions_ibfk_1` FOREIGN KEY (`exam_user_id`) REFERENCES `exam_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for exam_user
-- ----------------------------
DROP TABLE IF EXISTS `exam_user`;
CREATE TABLE `exam_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `exam_room_id` int(11) NULL DEFAULT 0 COMMENT '考场编号：\r\n默认:0:无考场\r\n非0:同exam_room表id',
  `user_id` int(11) NOT NULL COMMENT '人员id：同users表id',
  `user_s_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '人员编号：同users表s_num',
  `user_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '人员姓名：同users表name',
  `start_time` int(11) NULL DEFAULT NULL COMMENT '开始考试时间',
  `stop_time` int(11) NULL DEFAULT NULL COMMENT '结束考试时间',
  `delay` int(3) NOT NULL DEFAULT 0 COMMENT '延迟时间：\r\n默认:0:不延时\r\n非0:进行延时',
  `flag` int(1) NOT NULL DEFAULT 0 COMMENT '考试情况：\r\n默认:0:正常\r\n1:迟到\r\n2:作弊\r\n3:出现异常',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id`) USING BTREE,
  INDEX `user_s_num`(`user_s_num`) USING BTREE,
  INDEX `user_name`(`user_name`) USING BTREE,
  CONSTRAINT `exam_user_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `exam_user_ibfk_2` FOREIGN KEY (`user_s_num`) REFERENCES `users` (`s_num`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `exam_user_ibfk_3` FOREIGN KEY (`user_name`) REFERENCES `users` (`name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for manage
-- ----------------------------
DROP TABLE IF EXISTS `manage`;
CREATE TABLE `manage`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '管理员用户名',
  `pw` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '管理员密码',
  `created_at` int(11) NOT NULL COMMENT '创建时间',
  `updated_at` int(11) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for manage_log
-- ----------------------------
DROP TABLE IF EXISTS `manage_log`;
CREATE TABLE `manage_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `manage_id` int(11) NOT NULL COMMENT '管理用户编号，同表 manage 表 id',
  `action_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '127.0.0.1' COMMENT '操作ip地址',
  `action_time` int(11) NOT NULL COMMENT '操作时间',
  `action` int(1) NOT NULL COMMENT '动作：\r\n默认0:登录成功\r\n1:更新\r\n2:删除\r\n3:登出\r\n4:尝试登录，密码错误',
  `last_sql` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '操作的SQL语句',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `manage_id`(`manage_id`) USING BTREE,
  CONSTRAINT `manage_log_ibfk_1` FOREIGN KEY (`manage_id`) REFERENCES `manage` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for pic
-- ----------------------------
DROP TABLE IF EXISTS `pic`;
CREATE TABLE `pic`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `target` int(1) NULL DEFAULT NULL COMMENT '图片归类：\r\n1:banner头图片',
  `src` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '图片地址',
  `show_tag` int(1) NOT NULL DEFAULT 0 COMMENT '显示状态：\r\n默认:0:正常显示\r\n1:隐藏',
  `del_tag` int(1) NOT NULL DEFAULT 0 COMMENT '删除标识位：\r\n默认:0:正常显示\r\n1:删除',
  `add_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '添加人',
  `created_at` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for question_option
-- ----------------------------
DROP TABLE IF EXISTS `question_option`;
CREATE TABLE `question_option`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `question_id` int(11) NOT NULL COMMENT '试题编号：同 questions 表id',
  `option` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '选项编号',
  `option_value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '选项内容',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `question_id`(`question_id`) USING BTREE,
  CONSTRAINT `question_option_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for questions
-- ----------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `type_tag` int(1) NOT NULL COMMENT '试题类型：\r\n0:判断正误题\r\n1:单选题\r\n2:多选题\r\n3:填空题\r\n4:不定项选择题',
  `topic` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '题目（包括括号）',
  `true_answer` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '正确答案',
  `warehouse_id` int(11) UNSIGNED NULL DEFAULT 0 COMMENT '隶属试题库：\r\n默认:0:无试题库\r\n非零:同question_warehouse表id',
  `del_tag` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除标识位：\r\n默认:0:正常显示\r\n1:删除',
  `add_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '添加人',
  `created_at` int(11) NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `s_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '人员编号',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '人员姓名',
  `sex` int(1) NOT NULL COMMENT '人员性别',
  `card` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '人员凭证：必须唯一！',
  `pw` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '密码',
  `src` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '人员照片地址',
  `type_id` int(11) NULL DEFAULT NULL COMMENT '人员分类id\r\n默认:0:暂未分类\r\n非0:同user_type表中id',
  `section_id` int(11) NULL DEFAULT NULL COMMENT '人员部门id\r\n默认:0:无部门\r\n非0:同section表中id',
  `add_user` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '添加人',
  `created_at` int(11) NOT NULL COMMENT '创建时间',
  `l_time` int(11) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `s_num`(`s_num`) USING BTREE,
  INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

SET FOREIGN_KEY_CHECKS = 1;
