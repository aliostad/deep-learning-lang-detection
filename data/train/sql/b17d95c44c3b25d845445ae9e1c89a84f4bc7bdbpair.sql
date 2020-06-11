/*
Navicat MySQL Data Transfer

Source Server         : snake.ics.uci.edu - synonyms
Source Server Version : 50528
Source Host           : snake.ics.uci.edu:3306
Source Database       : synonyms

Target Server Type    : MYSQL
Target Server Version : 50528
File Encoding         : 65001

Date: 2013-08-14 11:51:45
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `pair`
-- ----------------------------
DROP TABLE IF EXISTS `pair`;
CREATE TABLE `pair` (
  `word1` varchar(255) NOT NULL,
  `word2` varchar(255) NOT NULL,
  `type` char(1) DEFAULT 's',
  PRIMARY KEY (`word1`,`word2`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pair
-- ----------------------------
INSERT INTO pair VALUES ('unzip', 'extract', 's');
INSERT INTO pair VALUES ('zip', 'compress', 's');
INSERT INTO pair VALUES ('to', 'convert', 's');
INSERT INTO pair VALUES ('to', '2', 's');
INSERT INTO pair VALUES ('util', 'helper', 's');
INSERT INTO pair VALUES ('begins', 'init', 's');
INSERT INTO pair VALUES ('create', 'new', 's');
INSERT INTO pair VALUES ('make', 'new', 's');
INSERT INTO pair VALUES ('check', 'if', 's');
INSERT INTO pair VALUES ('test', 'if', 's');
INSERT INTO pair VALUES ('exceeds', 'greater', 's');
INSERT INTO pair VALUES ('check', 'is', 's');
INSERT INTO pair VALUES ('full', 'max', 's');
INSERT INTO pair VALUES ('create', 'clone', 's');
INSERT INTO pair VALUES ('save', 'output', 's');
INSERT INTO pair VALUES ('dumps', 'export', 's');
INSERT INTO pair VALUES ('add', 'plus', 's');
INSERT INTO pair VALUES ('remove', 'cleanup', 's');
INSERT INTO pair VALUES ('same', 'equal', 's');
INSERT INTO pair VALUES ('delete', 'remove', 's');
INSERT INTO pair VALUES ('start', 'begin', 's');
INSERT INTO pair VALUES ('make', 'create', 's');
INSERT INTO pair VALUES ('add', 'append', 's');
INSERT INTO pair VALUES ('determine', 'check', 's');
INSERT INTO pair VALUES ('write', 'save', 's');
INSERT INTO pair VALUES ('display', 'show', 's');
INSERT INTO pair VALUES ('nothing', 'null', 's');
INSERT INTO pair VALUES ('last', 'end', 's');
INSERT INTO pair VALUES ('first', 'start', 's');
INSERT INTO pair VALUES ('clone', 'copy', 's');
INSERT INTO pair VALUES ('create', 'construct', 's');
INSERT INTO pair VALUES ('new', 'make', 's');
INSERT INTO pair VALUES ('node', 'entry', 's');
INSERT INTO pair VALUES ('token', 'element', 's');
INSERT INTO pair VALUES ('copy', 'instance', 's');
INSERT INTO pair VALUES ('link', 'reference', 's');
INSERT INTO pair VALUES ('search', 'find', 's');
INSERT INTO pair VALUES ('give', 'specify', 's');
INSERT INTO pair VALUES ('entry', 'element', 's');
INSERT INTO pair VALUES ('append', 'insert', 's');
INSERT INTO pair VALUES ('value', 'element', 's');
INSERT INTO pair VALUES ('get', 'return', 's');
INSERT INTO pair VALUES ('node', 'element', 's');
INSERT INTO pair VALUES ('node', 'token', 's');
INSERT INTO pair VALUES ('or', 'either', 's');
INSERT INTO pair VALUES ('soft', 'weak', 's');
INSERT INTO pair VALUES ('error', 'warning', 's');
INSERT INTO pair VALUES ('node', 'value', 's');
INSERT INTO pair VALUES ('identity', 'reference', 's');
INSERT INTO pair VALUES ('zip', 'unzip', 'a');
INSERT INTO pair VALUES ('pack', 'unpack', 'a');
INSERT INTO pair VALUES ('tar', 'untar', 'a');
INSERT INTO pair VALUES ('decompress', 'unzip', 's');
INSERT INTO pair VALUES ('legal', 'illegal', 'a');
INSERT INTO pair VALUES ('bounded', 'unbounded', 'a');
INSERT INTO pair VALUES ('uncompress', 'unzip', 's');
INSERT INTO pair VALUES ('disabled', 'off', 's');
INSERT INTO pair VALUES ('interrupt', 'irq', 's');
INSERT INTO pair VALUES ('call', 'invoke', 's');
INSERT INTO pair VALUES ('mounted', 'accessible', 's');
INSERT INTO pair VALUES ('size', 'capacity', 's');
INSERT INTO pair VALUES ('associate', 'map', 's');
INSERT INTO pair VALUES ('mask', 'disable', 's');
INSERT INTO pair VALUES ('initialize', 'setup', 's');
INSERT INTO pair VALUES ('add', 'alloc', 's');
INSERT INTO pair VALUES ('int', 'integer', 'b');
INSERT INTO pair VALUES ('impl', 'implement', 'b');
INSERT INTO pair VALUES ('obj', 'object', 'b');
INSERT INTO pair VALUES ('pos', 'position', 'b');
INSERT INTO pair VALUES ('init', 'initial', 'b');
INSERT INTO pair VALUES ('len', 'length', 'b');
INSERT INTO pair VALUES ('attr', 'attribute', 'b');
INSERT INTO pair VALUES ('num', 'number', 'b');
INSERT INTO pair VALUES ('env', 'environment', 'b');
INSERT INTO pair VALUES ('val', 'value', 'b');
INSERT INTO pair VALUES ('str', 'string', 'b');
INSERT INTO pair VALUES ('buff', 'buffer', 'b');
INSERT INTO pair VALUES ('ctx', 'context', 'b');
INSERT INTO pair VALUES ('msg', 'message', 'b');
INSERT INTO pair VALUES ('var', 'variable', 'b');
INSERT INTO pair VALUES ('elem', 'element', 'b');
INSERT INTO pair VALUES ('param', 'parameter', 'b');
INSERT INTO pair VALUES ('decl', 'declare', 'b');
INSERT INTO pair VALUES ('arg', 'argument', 'b');
