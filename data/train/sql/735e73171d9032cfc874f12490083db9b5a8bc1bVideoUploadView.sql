-- ViewName : VideoUploadView
start transaction;
# module
SELECT @FKModule := IDModule FROM lkp_module WHERE ModuleName = 'Media';
# delete columns
SELECT @idView := ifnull((SELECT IDListView FROM listview_master WHERE ViewName = 'VideoUploadView'), -1);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_columns WHERE fklistview = @idView);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_sortoption WHERE fklistview = @idView);
DELETE FROM listview_fieldmaster WHERE idlistviewfield IN (SELECT fklistviewfield FROM listview_groupbyoption WHERE fklistview = @idView);

# delete criteria
SELECT @idCriteria := ifnull((SELECT FKListViewCriteria FROM listview_master WHERE IDListView = @idView), -1);
DELETE FROM listview_criteria WHERE IDListViewCriteria = @idCriteria;

DELETE FROM listview_master WHERE IDListView = @idView;

# UPDATE sequence
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListViewField),0) FROM listview_fieldmaster) WHERE seq_name = 'MasterField_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListViewCriteria),0) FROM listview_criteria) WHERE seq_name = 'ListCriteria_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListViewFieldMapping),0) FROM listview_fieldmapping) WHERE seq_name = 'ListFieldMapping_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListView),0) FROM listview_master WHERE IsCustomList = 0) WHERE seq_name = 'ListBox_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListViewSortby),0) FROM listview_sortoption) WHERE seq_name = 'ListSortby_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListColumn),0) FROM listview_columns) WHERE seq_name = 'ListColumn_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDProductViewMenu),0) FROM cnf_productviewmenu) WHERE seq_name = 'CNF_ProductViewMenu_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListActionItem),0) FROM listview_actionlinks) WHERE seq_name = 'ListAction_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListViewFilterBy),0) FROM listview_filteroption) WHERE seq_name = 'ListFilterby_SEQ';
UPDATE sequence_table SET seq_count = (SELECT ifnull(max(IDListViewGroupby),0) FROM listview_groupbyoption) WHERE seq_name = 'ListGroupby_SEQ';

-- retrieve max value for each table
SELECT @IDListViewFieldMaster := ifnull(max(IDListViewField), 0) FROM listview_fieldmaster;
SELECT @IDListViewCriteria := ifnull(max(IDListViewCriteria), 0) FROM listview_criteria;
SELECT @IDListViewFieldMapping := ifnull(max(IDListViewFieldMapping), 0) FROM listview_fieldmapping;
SELECT @IDListView := ifnull(max(IDListView), 0) FROM listview_master;
SELECT @IDListViewSortby := ifnull(max(IDListViewSortby), 0) FROM listview_sortoption;
SELECT @IDListColumn := ifnull(max(IDListColumn), 0) FROM listview_columns;
SELECT @IDProductViewMenu := ifnull(max(IDProductViewMenu), 0) FROM cnf_productviewmenu;
SELECT @IDListActionItem := ifnull(max(IDListActionItem), 0) FROM listview_actionlinks;
SELECT @IDListViewFilterBy := ifnull(max(IDListViewFilterBy), 0) FROM listview_filteroption;
SELECT @IDListViewGroupby := ifnull(max(IDListViewGroupby), 0) FROM listview_groupbyoption;

-- Hidden ID Column (MediaDocument.IDMediaDocument)
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) 
VALUES (@IDListViewFieldMaster+1,'idmediadocument','videouploadview.columnname.idmediadocument','INTEGER','0');

-- Column 1: Thumbnail (MediaDocument.SupportingDocument_DocID)
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) 
VALUES (@IDListViewFieldMaster+2,'guid','videouploadview.columnname.Thumbnail','VARCHAR','100');

-- Column 2: File Name (MediaDocument.FileName)
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) 
VALUES (@IDListViewFieldMaster+3,'filename','videouploadview.columnname.filename','VARCHAR','180');

-- Column 3: File Type (MediaDocument.FileType)
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) 
VALUES (@IDListViewFieldMaster+4,'filetype','videouploadview.columnname.filetype','VARCHAR','150');

-- Column 4: Size (MediaDocument.FileSize)
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) 
VALUES (@IDListViewFieldMaster+5,'size','videouploadview.columnname.size','VARCHAR','100');

-- Column 5: Dimensions (MediaDocument.ImageWidth - MediaDocument.ImageHeight)
INSERT INTO listview_fieldmaster (IDListViewField,DBColumnName, ListHeaderName, DBColumnDatatype, ListHeaderWidth) 
VALUES (@IDListViewFieldMaster+6,'dimensions','videouploadview.columnname.dimensions','VARCHAR','150');


INSERT INTO listview_criteria (IDListViewCriteria, TableName, Criteria) 
VALUES (@IDListViewCriteria+1, "(
	select idmediadocument, guid, filename, filetype, size, dimensions from (
	select
    	m.IDMediaDocument as idmediadocument,
       	m.SupportingDocument_DocID as guid,
		m.FileName as filename,
		m.FileType as filetype,
		m.FileSize as size,
		concat_ws('x', m.ImageWidth, m.ImageHeight) as dimensions
		from mediadocument m
		where m.IDMediaDocument in (@uploadedVideoIds) and m.MediaType='Video' and m.FKProject=@fkProject) as doc group by idmediadocument
	)as masterView",'1=1');       	
       	
       	
SELECT @idmap := ifnull(MAX(id),0) FROM
(
	SELECT MAX(IDListMap) as id
	FROM listview_fieldmapping
	UNION ALL
	SELECT MAX(FieldMapping) as id
	FROM listview_master
) as MaxListMap;

INSERT INTO listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) VALUES(@IDListViewFieldMapping+1, @IDListViewFieldMaster+1, (SELECT @idmap+1), 0, 1, 0);
INSERT INTO listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) VALUES(@IDListViewFieldMapping+2, @IDListViewFieldMaster+2, (SELECT @idmap+1), 1, 0, 0);
INSERT INTO listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) VALUES(@IDListViewFieldMapping+3, @IDListViewFieldMaster+3, (SELECT @idmap+1), 1, 1, 0);
INSERT INTO listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) VALUES(@IDListViewFieldMapping+4, @IDListViewFieldMaster+4, (SELECT @idmap+1), 1, 1, 0);
INSERT INTO listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) VALUES(@IDListViewFieldMapping+5, @IDListViewFieldMaster+5, (SELECT @idmap+1), 1, 1, 0);
INSERT INTO listview_fieldmapping (IDListViewFieldMapping,FKListViewField, IDListMap, IsView, IsFilter, IsGroup) VALUES(@IDListViewFieldMapping+6, @IDListViewFieldMaster+6, (SELECT @idmap+1), 1, 1, 0);

INSERT INTO listview_master (IDListView,FKModule, ViewName, FKListViewCriteria, FieldMapping, IsCustomList,FKUser,FKProductViewMenu) 
VALUES (@IDListView+1, @FKModule, 'VideoUploadView', @IDListViewCriteria+1, (SELECT @idmap+1),0,1, null);

INSERT INTO listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) VALUES(@IDListColumn+1, @IDListView+1,@IDListViewFieldMaster+1,0);
INSERT INTO listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) VALUES(@IDListColumn+2, @IDListView+1,@IDListViewFieldMaster+2,1);
INSERT INTO listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) VALUES(@IDListColumn+3, @IDListView+1,@IDListViewFieldMaster+3,2);
INSERT INTO listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) VALUES(@IDListColumn+4, @IDListView+1,@IDListViewFieldMaster+4,3);
INSERT INTO listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) VALUES(@IDListColumn+5, @IDListView+1,@IDListViewFieldMaster+5,4);
INSERT INTO listview_columns (IDListColumn,FKListView, FKListViewField, DisplayOrder) VALUES(@IDListColumn+6, @IDListView+1,@IDListViewFieldMaster+6,5);

-- retrieve max value for each table
SELECT @IDListViewFieldMaster := ifnull(max(IDListViewField), 0) FROM listview_fieldmaster;
SELECT @IDListViewCriteria := ifnull(max(IDListViewCriteria), 0) FROM listview_criteria;
SELECT @IDListViewFieldMapping := ifnull(max(IDListViewFieldMapping), 0) FROM listview_fieldmapping;
SELECT @IDListView := ifnull(max(IDListView), 0) FROM listview_master;
SELECT @IDListViewSortby := ifnull(max(IDListViewSortby), 0) FROM listview_sortoption;
SELECT @IDListColumn := ifnull(max(IDListColumn), 0) FROM listview_columns;
SELECT @IDProductViewMenu := ifnull(max(IDProductViewMenu), 0) FROM cnf_productviewmenu;
SELECT @IDListActionItem := ifnull(max(IDListActionItem), 0) FROM listview_actionlinks;
SELECT @IDListViewFilterBy := ifnull(max(IDListViewFilterBy), 0) FROM listview_filteroption;
SELECT @IDListViewGroupby := ifnull(max(IDListViewGroupby), 0) FROM listview_groupbyoption;

-- UPDATE sequence tables
UPDATE sequence_table SET seq_count = @IDListViewFieldMaster+1 WHERE seq_name = 'MasterField_SEQ';
UPDATE sequence_table SET seq_count = @IDListViewCriteria+1 WHERE seq_name = 'ListCriteria_SEQ';
UPDATE sequence_table SET seq_count = @IDListViewFieldMapping+1 WHERE seq_name = 'ListFieldMapping_SEQ';
UPDATE sequence_table SET seq_count = @IDListView+1 WHERE seq_name = 'ListBox_SEQ';
UPDATE sequence_table SET seq_count = @IDListViewSortby+1 WHERE seq_name = 'ListSortby_SEQ';
UPDATE sequence_table SET seq_count = @IDListColumn+1 WHERE seq_name = 'ListColumn_SEQ';
UPDATE sequence_table SET seq_count = @IDProductViewMenu+1 WHERE seq_name = 'CNF_ProductViewMenu_SEQ';
UPDATE sequence_table SET seq_count = @IDListActionItem+1 WHERE seq_name = 'ListAction_SEQ';
UPDATE sequence_table SET seq_count = @IDListViewFilterBy+1 WHERE seq_name = 'ListFilterby_SEQ';
UPDATE sequence_table SET seq_count = @IDListViewGroupby+1 WHERE seq_name = 'ListGroupby_SEQ';
COMMIT;
#rollback;