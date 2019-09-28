/*
 Navicat Premium Data Transfer

 Source Server         : 本机
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : newexam

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 28/09/2019 17:49:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for demo
-- ----------------------------
DROP TABLE IF EXISTS `demo`;
CREATE TABLE `demo`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for exam
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for manage
-- ----------------------------
DROP TABLE IF EXISTS `manage`;
CREATE TABLE `manage`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自动编号',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '管理员用户名',
  `pw` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '管理员密码',
  `created_at` int(11) NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` int(11) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
