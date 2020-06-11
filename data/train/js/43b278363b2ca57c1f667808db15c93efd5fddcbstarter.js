function createAddTable() {
	var controller = new addTableController;
	controller.loadView();
};

function addButtonPanel() {
	var controller = new buttonPanelController;
	controller.loadView();
};

function addDisplayRow() {
	var controller = new displayRowController;
	controller.addApartment();
};

//When zip search is run, call this
function addDisplayRowsThroughSearch(zip) {
	var controller = new displayRowController;
	controller.zipSearch(zip);
}

function clearDisplayRows() {
	var controller = new clearController;
	controller.clearEntries();
}

function saveState(pass) {
	var controller = new stateController;
	controller.saveResults(pass);
}

function loadState(pass) {
	var controller = new stateController;
	controller.loadResults(pass);
}

function initDB() {
	var controller = new stateController;
	controller.initDB();
}

function clearDB() {
	var controller = new stateController;
	controller.clearDB();
}

createAddTable();

addButtonPanel();

//Create a single displayRowController here, remove addDisplayRow (controllers.js)