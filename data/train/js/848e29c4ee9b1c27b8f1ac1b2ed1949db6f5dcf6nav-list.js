var navList = new Object();

function createNavList(table, data){
	navList.table = table;
	navList.data = data;
	navListRefresh();
}

function navListMoveUp(event){
	var i = parseInt(event.target.name);
	if(i == 0)
		return;
	var tmp = navList.data[i - 1];
	navList.data[i - 1] = navList.data[i];
	navList.data[i] = tmp;
	navListRefresh();
}

function navListMoveDown(event){
	var i = parseInt(event.target.name);
	if(i == navList.data.length - 1)
		return;
	var tmp = navList.data[i + 1];
	navList.data[i + 1] = navList.data[i];
	navList.data[i] = tmp;
	navListRefresh();
}

function navListRemove(event){
	var i = parseInt(event.target.name);
	for(var t = i; t < navList.data.length - 1; t ++)
		navList.data[i] = navList.data[i + 1];
	-- navList.data.length;
	navListRefresh();
}

function navListAddItem(label, url){
	navList.data.push({
		label: label,
		url: url
	});
	navListRefresh();
}

function navListGetData(){
	return navList.data;
}

function navListRefresh(){
	navList.table.empty();
	navList.table.append("<tr><th>Label</th><th>URL</th><th>Operation</th></tr>");
	for(var i = 0; i < navList.data.length; i ++){
		var row = $("<tr><td>" + navList.data[i].label + "</td><td>" +
			navList.data[i].url + "</td></tr>");
		var td = $("<td></td>");
		var btn_up = $("<button type=\"button\" class=\"btn btn-primary btn-sm\" name=\"" + i + "_nav\">Up</button>");
		var btn_down = $("<button type=\"button\" class=\"btn btn-primary btn-sm\" name=\"" + i + "_nav\">Down</button>");
		var btn_rm = $("<button type=\"button\" class=\"btn btn-danger btn-sm\" name=\"" + i + "_nav\">Remove</button>");

		btn_up.click(navListMoveUp);
		btn_down.click(navListMoveDown);
		btn_rm.click(navListRemove);
		td.append(btn_up);
		td.append(btn_down);
		td.append(btn_rm);
		row.append(td);
		navList.table.append(row);
	}
}

