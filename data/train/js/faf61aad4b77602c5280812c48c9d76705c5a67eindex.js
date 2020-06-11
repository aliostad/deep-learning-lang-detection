// GRAPHICAL USER INTERFACE CONTROLLER

import Pane from './src/pane.js';
import Tab from './src/tab.js';
import { Bin, GridBin, ListBin, CollectionBin } from './src/bin/index.js';
import {
	ActionController,
	CanvasController,
	ColorController,
	DropdownController,
	GridController,
	HTMLController,
	InfoController,
	NumberController,
	TextController,
	ToggleController
} from './src/controller/index.js';

export default {
	Pane,
	Tab,
	Bin,
	GridBin,
	ListBin,
	CollectionBin,
	ActionController,
	CanvasController,
	ColorController,
	DropdownController,
	GridController,
	HTMLController,
	InfoController,
	NumberController,
	TextController,
	ToggleController
};

// Webpack: load stylesheet
require('./styles/main.less');

