function ViewShowList(rpc) {
	this.rpc = rpc;
	this.showItemList = new ViewShowItemList(rpc);
	
	this.$showSelectDropdown = $( "#showselect" );
	this.selectedShow = "";
	
	this.$containerHtmlPart = $("#agenda");
	this.$htmlPart = $("#showselect");
	
	this.rpcProxy = this.rpc.ViewShowListRpc;
	
	this.activateView();
}

ViewShowList.prototype.initView = function() {
	var me = this;
	this.$showSelectDropdown.multiselect({
		multiple: false,
		header: false,
		noneSelectedText: "- Select Show -",
		selectedList: 1
	});
	this.$showSelectDropdown.bind("multiselectclick", function(event, ui){
		me.selectShow(ui.value);
	});
	
	this.showItemList.initView();
}

ViewShowList.prototype.activateView = function() {
	this.$containerHtmlPart.append(this.$htmlPart);
	this.$htmlPart.show();
}

ViewShowList.prototype.selectShow = function(id) {
	this.showItemList.displayShow(id);
}

ViewShowList.prototype.reloadShowList = function() {
	var me = this;
	this.rpcProxy.getAllShows('', function(jsonRpcObj) {
		console.log(jsonRpcObj);
		me.buildShowList(jsonRpcObj.result);
	});
}

ViewShowList.prototype.buildShowList = function(shows) {
	this.$showSelectDropdown.empty();
	$itemOption = $('<option></option');
	$itemOption.html('- Select Show -');
	this.$showSelectDropdown.append($itemOption);
	for (var i = 0; i < shows.length; i++) {
		var crntShow = shows[i];
		$itemOption = $('<option></option>');
		$itemOption.val(crntShow.id);
		$itemOption.html(crntShow.title);
		this.$showSelectDropdown.append($itemOption);
	}
	// refresh
	this.$showSelectDropdown.multiselect({
		multiple: false
	});
}

