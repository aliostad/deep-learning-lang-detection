USE gpms;

--初始化序列表
INSERT INTO SYS_TABLESEQ(SEQ_ID)
VALUES (3);

--初始化导航菜单
INSERT INTO SYS_NAVIGATOR
      (
          NAV_ID, NAV_NAME, NAV_URL, NAL_STATUS, NAV_SEQ
      )
VALUES (1, '系统管理', '', 1, 1);

--初始化树形菜单
INSERT INTO SYS_MENU
      (
          MENU_ID,
          NAV_ID,
          MENU_TITLE,
          MENU_CODE,
          MENU_URL,
          MENU_SEQ,
          MENU_STATUS,
          MENU_PARENT_ID
      )
VALUES (2, 1, '系统管理', '01', '', 1, 1, 0);

INSERT INTO SYS_MENU
      (
          MENU_ID,
          NAV_ID,
          MENU_TITLE,
          MENU_CODE,
          MENU_URL,
          MENU_SEQ,
          MENU_STATUS,
          MENU_PARENT_ID
      )
VALUES (3, 1, '导航菜单设置', '0101', '', 1, 1, 2);