/*
{
	id:'code_tbl',
	params_update:'_q=system/code/update&rid=${param.rid}',
	params_insert:'_q=system/code/insert',
	button_edit: '_q=system/code/edit&rid=${param.rid}',
	singleRow:true,
	hidden:'rid',
	img: 'reference_value',
	read_only:'contents_nm',
	edit_comment: {
		code_name: '이 항목에 대한 설명입니다.[${row.code_name}]',
		order_no: '<font color="green">이 항목에 대한 설명입니다.</font>'
	},
	form_comment: 
		'<font color="red">
			form_comment에 입력한 내용은 현재 메세지 위치에 표시됩니다.[${row.code_name}]
		</font>
		<br>
		<div id="_target_div1">
			<div><br><br><b>이 페이지는 javascript를 사용하여 전체적인 UI를 재배치 한 예제입니다.</b><br></div>
			<div id="_target_div2"></div>
		</div>',
	javascript: '
		$("body").append($("#_target_div1"));
		$("#_target_div2").append($("#_content_main_"));
		
		alert("javascript를 사용한 예제 입니다.[${row.code_name}]");
	'
}
*/
SELECT *
FROM code_tbl
WHERE rid = @{rid};
