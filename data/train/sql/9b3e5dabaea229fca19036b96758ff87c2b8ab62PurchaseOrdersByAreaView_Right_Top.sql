-- ViewName : PurchaseOrdersByAreaView_Right_Top
start transaction;
# module
select @FKModule := IDModule from lkp_module where ModuleName = 'Purchase Orders Invoices';
# delete columns
SELECT @idView := ifnull((select IDListView from listview_master WHERE ViewName = 'PurchaseOrdersByAreaView_Right_Top'), -1);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_columns WHERE fklistview = @idView);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_sortoption WHERE fklistview = @idView);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_groupbyoption WHERE fklistview = @idView);

# delete criteria
SELECT @idCriteria := ifnull((select FKListViewCriteria FROM listview_master WHERE IDListView = @idView), -1);
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

INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+1,'idProject','po.listview.projectbyarea.columnname.idproject','INTEGER','100');
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+2,'projectPrefix','po.listview.projectbyarea.columnname.projectprefix','VARCHAR','180');
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) VALUES (@IDListViewFieldMaster+3,'projectName','po.listview.projectbyarea.columnname.projectname','VARCHAR','130');

INSERT INTO listview_criteria (IDListViewCriteria, TableName, Criteria) VALUES (@IDListViewCriteria+1, "(select p.IDProject  as idProject ,concat_ws(\'\',cnf_ppx.prefix,p.number) as projectPrefix,p.Name as projectName,area.IDArea as idArea, poInvoice.idpurchaseorderinvoice from project p left join cnf_projectprefix cnf_ppx on p.FKProjectPrefix=cnf_ppx.IDProjectPrefix inner join cnf_acllevel acl on p.FKACLLevel=acl.IDACLLevel inner join cnf_area area on area.IDArea=acl.TargetID inner join purchaseorderinvoice poInvoice on poInvoice.FKProject=p.IDProject where poInvoice.POType=\'PO\' group by p.IDProject) as a", 'idArea=@IDArea');

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

insert into listview_master (IDListView,FKModule, ViewName, FKListViewCriteria, FieldMapping, IsCustomList,FKUser,FKProductViewMenu) values (@IDListView+1, @FKModule, 'PurchaseOrdersByAreaView_Right_Top', @IDListViewCriteria+1, (SELECT @idmap+1),0,1, null);

insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+1, @IDListView+1,@IDListViewFieldMaster+1,0);
insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+2, @IDListView+1,@IDListViewFieldMaster+2,1);
insert into listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) values(@IDListColumn+3, @IDListView+1,@IDListViewFieldMaster+3,2);

insert into listview_sortoption (IDListViewSortby,FKListView, FKListViewField, OrderSequence) values(@IDListViewSortby+1,@IDListView+1,@IDListViewFieldMaster+1,'ASC');
insert into listview_sortoption (IDListViewSortby,FKListView, FKListViewField, OrderSequence) values(@IDListViewSortby+2,@IDListView+1,@IDListViewFieldMaster+2,'ASC');
insert into listview_sortoption (IDListViewSortby,FKListView, FKListViewField, OrderSequence) values(@IDListViewSortby+3,@IDListView+1,@IDListViewFieldMaster+3,'ASC');

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