/*
 *
 *  Created on: 07.07.2012
 *	Author: Tobias Kohlbau <tobias.kohlbau@gmail.com>
 *
 */

#include "Load.h"

Load::Load() {
	setPath("");
	setName("");
}

Load::Load(std::string loadPath, std::string loadName) {
	setPath(loadPath);
	setName(loadName);
}

double Load::getAverage() {
	std::string loadOne = getContent(getPath() + "/" + getName());
	loadOne = loadOne.replace(loadOne.find("  "), loadOne.find("  ") + 1, " ");
	usleep(500000);
	std::string loadTwo = getContent(getPath() + "/" + getName());
	loadTwo = loadTwo.replace(loadTwo.find("  "), loadTwo.find("  ") + 1, " ");
	std::string one[5];
	std::string two[5];
	double oneComplete = 0;
	double twoComplete = 0;
	for (int i = 0; i < 5; i++) {
		one[i] = loadOne.substr(0, loadOne.find(" "));
		two[i] = loadTwo.substr(0, loadTwo.find(" "));
		loadOne = loadOne.replace(0, one[i].length() + 1, "");
		loadTwo = loadTwo.replace(0, two[i].length() + 1, "");
		if (i > 0) {
			oneComplete += stod(one[i]);
			twoComplete += stod(two[i]);
		}
	}
	return (1 - ((stod(one[4]) - stod(two[4])) / (oneComplete - twoComplete)));
}
