create database EDF DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2011/7/8 10:02:54                            */
/*==============================================================*/


drop table if exists SYS_MENU;

drop table if exists SYS_NAVIGATOR;

drop table if exists SYS_TABLESEQ;

/*==============================================================*/
/* Table: SYS_MENU                                              */
/*==============================================================*/
create table SYS_MENU
(
   MENU_ID              int not null comment '菜单id',
   NAV_ID               smallint comment '导航菜单id',
   MENU_TITLE           varchar(50) comment '菜单标题',
   MENU_CODE            varchar(50) comment '菜单编码',
   MENU_URL             varchar(500) comment '菜单url',
   MENU_SEQ             smallint comment '菜单序号',
   MENU_STATUS          tinyint comment '菜单状态:0-停用 1-启用',
   MENU_PARENT_ID       int comment '菜单父节点id',
   MENU_NOTE            varchar(255) comment '菜单备注',
   primary key (MENU_ID)
)
comment = "树形菜单";

/*==============================================================*/
/* Table: SYS_NAVIGATOR                                         */
/*==============================================================*/
create table SYS_NAVIGATOR
(
   NAV_ID               smallint not null comment '菜单id',
   NAV_NAME             varchar(50) comment '菜单名称',
   NAV_URL              varchar(500) comment '菜单url',
   NAL_STATUS           tinyint comment '菜单状态:0-停用 1-启用',
   NAV_SEQ              tinyint comment '菜单序号',
   NAV_NOTE             varchar(255) comment '菜单备注',
   primary key (NAV_ID)
)
comment = "导航菜单";

/*==============================================================*/
/* Table: SYS_TABLESEQ                                          */
/*==============================================================*/
create table SYS_TABLESEQ
(
   SEQ_ID               bigint not null,
   primary key (SEQ_ID)
)
comment = "序列表";

alter table SYS_MENU add constraint FK_Reference_1 foreign key (NAV_ID)
      references SYS_NAVIGATOR (NAV_ID) on delete restrict on update restrict;

