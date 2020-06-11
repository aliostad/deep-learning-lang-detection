-- ViewName : ProjectBidList-Right
start transaction;
# module
select @FKModule := IDModule from lkp_module where ModuleName = 'BQM';
# delete columns
SELECT @idView := ifnull((select IDListView from listview_master WHERE ViewName = 'ProjectBidList-Right'), -1);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_columns WHERE fklistview = @idView);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_sortoption WHERE fklistview = @idView);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_groupbyoption WHERE fklistview = @idView);

# delete criteria
SELECT @idCriteria := ifnull((select FKListViewCriteria FROM listview_master WHERE IDListView = @idView), -1)
DELETE FROM listview_criteria WHERE IDListViewCriteria = @idCriteria;

DELETE FROM listview_master WHERE IDListView = @idView;

# update sequence
update sequence_table set seq_count = (select ifnull(max(IDListViewField),0) from listview_fieldmaster) where seq_name = 'MasterField_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListViewCriteria),0) from listview_criteria) where seq_name = 'ListCriteria_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListViewFieldMapping),0) from listview_fieldmapping) where seq_name = 'ListFieldMapping_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListView),0) from listview_master where IsCustomList = 0) where seq_name = 'ListBox_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListViewSortby),0) from listview_sortoption) where seq_name = 'ListSortby_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListColumn),0) from listview_columns) where seq_name = 'ListColumn_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDProductViewMenu),0) from cnf_productviewmenu) where seq_name = 'CNF_ProductViewMenu_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListActionItem),0) from listview_actionlinks) where seq_name = 'ListAction_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListViewFilterBy),0) from listview_filteroption) where seq_name = 'ListFilterby_SEQ';
update sequence_table set seq_count = (select ifnull(max(IDListViewGroupby),0) from listview_groupbyoption) where seq_name = 'ListGroupby_SEQ';

-- retrieve max value for each table
select @IDListViewFieldMaster := ifnull(max(IDListViewField), 0) from listview_fieldmaster;
select @IDListViewCriteria := ifnull(max(IDListViewCriteria), 0) from listview_criteria;
select @IDListViewFieldMapping := ifnull(max(IDListViewFieldMapping), 0) from listview_fieldmapping;
select @IDListView := ifnull(max(IDListView), 0) from listview_master;
select @IDListViewSortby := ifnull(max(IDListViewSortby), 0) from listview_sortoption;
select @IDListColumn := ifnull(max(IDListColumn), 0) from listview_columns;
select @IDProductViewMenu := ifnull(max(IDProductViewMenu), 0) from cnf_productviewmenu;
select @IDListActionItem := ifnull(max(IDListActionItem), 0) from listview_actionlinks;
select @IDListViewFilterBy := ifnull(max(IDListViewFilterBy), 0) from listview_filteroption;
select @IDListViewGroupby := ifnull(max(IDListViewGroupby), 0) from listview_groupbyoption;

INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+1,'idproject','listview.columnname.projectbidlist.id','INTEGER','11');
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+2,'name','listview.columnname.projectbidlist.name','VARCHAR','300');
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+3,'construction','listview.columnname.projectbidlist.construction','VARCHAR','150');
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+4,'contract','listview.columnname.projectbidlist.contract','VARCHAR','175');
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+5,'closingdate','listview.columnname.projectbidlist.closingdate','VARCHAR','150');

INSERT INTO listview_criteria (IDListViewCriteria, TableName, Criteria) VALUES (@IDListViewCriteria+1, "(select p.idproject, concat_ws(\'-\', cast(p.number as char), cast(p.name as char)) as name, cast(p.constructionphase as char) as construction,  cast(p.originalcontractvalue as char) as contract, DATE_FORMAT(bis.closingdate, \'%Y-%m-%d %H:%i\') as closingdate from project p inner join bidlist b on  b.fkproject = p.idproject left join cnf_projectarea a on p.fkprojectarea = a.idprojectarea left join cnf_projectcategory pc on pc.idprojectcategory = p.fkprojectcategory left join  bidinformationsheet bis on p.idproject = bis.fkproject where a.idprojectarea @area and pc.idprojectcategory @category group by b.fkproject order by concat_ws(\'-\',  cast(p.number as char), cast(p.name as char))) as p", '1=1');

SELECT @idmap := ifnull(MAX(id),0) FROM
(
	SELECT MAX(IDListMap) as id
	FROM listview_fieldmapping
	UNION ALL
	SELECT MAX(FieldMapping) as id
	FROM listview_master
) as MaxListMap;

insert into listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) values(@IDListViewFieldMapping+1, @IDListViewFieldMaster+1, (select @idmap+1), 0, 0, 0);

insert into listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) values(@IDListViewFieldMapping+2, @IDListViewFieldMaster+2, (select @idmap+1), 1, 1, 0);

insert into listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) values(@IDListViewFieldMapping+3, @IDListViewFieldMaster+3, (select @idmap+1), 1, 1, 0);

insert into listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) values(@IDListViewFieldMapping+4, @IDListViewFieldMaster+4, (select @idmap+1), 1, 1, 0);

insert into listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) values(@IDListViewFieldMapping+5, @IDListViewFieldMaster+5, (select @idmap+1), 1, 1, 0);

insert into listview_master (IDListView,FKModule, ViewName, FKListViewCriteria, FieldMapping, IsCustomList,FKUser,FKProductViewMenu) values (@IDListView+1, @FKModule, 'ProjectBidList-Right', @IDListViewCriteria+1, (SELECT @idmap+1),0,1, null);

insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+1, @IDListView+1,@IDListViewFieldMaster+1,0);
insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+2, @IDListView+1,@IDListViewFieldMaster+2,1);
insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+3, @IDListView+1,@IDListViewFieldMaster+3,2);
insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+4, @IDListView+1,@IDListViewFieldMaster+4,3);
insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+5, @IDListView+1,@IDListViewFieldMaster+5,4);


-- retrieve max value for each table
select @IDListViewFieldMaster := ifnull(max(IDListViewField), 0) from listview_fieldmaster;
select @IDListViewCriteria := ifnull(max(IDListViewCriteria), 0) from listview_criteria;
select @IDListViewFieldMapping := ifnull(max(IDListViewFieldMapping), 0) from listview_fieldmapping;
select @IDListView := ifnull(max(IDListView), 0) from listview_master;
select @IDListViewSortby := ifnull(max(IDListViewSortby), 0) from listview_sortoption;
select @IDListColumn := ifnull(max(IDListColumn), 0) from listview_columns;
select @IDProductViewMenu := ifnull(max(IDProductViewMenu), 0) from cnf_productviewmenu;
select @IDListActionItem := ifnull(max(IDListActionItem), 0) from listview_actionlinks;
select @IDListViewFilterBy := ifnull(max(IDListViewFilterBy), 0) from listview_filteroption;
select @IDListViewGroupby := ifnull(max(IDListViewGroupby), 0) from listview_groupbyoption;

-- update sequence tables
update sequence_table set seq_count = @IDListViewFieldMaster+1 where seq_name = 'MasterField_SEQ';
update sequence_table set seq_count = @IDListViewCriteria+1 where seq_name = 'ListCriteria_SEQ';
update sequence_table set seq_count = @IDListViewFieldMapping+1 where seq_name = 'ListFieldMapping_SEQ';
update sequence_table set seq_count = @IDListView+1 where seq_name = 'ListBox_SEQ';
update sequence_table set seq_count = @IDListViewSortby+1 where seq_name = 'ListSortby_SEQ';
update sequence_table set seq_count = @IDListColumn+1 where seq_name = 'ListColumn_SEQ';
update sequence_table set seq_count = @IDProductViewMenu+1 where seq_name = 'CNF_ProductViewMenu_SEQ';
update sequence_table set seq_count = @IDListActionItem+1 where seq_name = 'ListAction_SEQ';
update sequence_table set seq_count = @IDListViewFilterBy+1 where seq_name = 'ListFilterby_SEQ';
update sequence_table set seq_count = @IDListViewGroupby+1 where seq_name = 'ListGroupby_SEQ';
commit;
#rollback;