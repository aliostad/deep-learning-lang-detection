import pickle
import tkMessageBox
import file

def saveGame(settings, gameEnded):
	canvas = settings["canvas"]
	if not gameEnded():
		if file.exists(settings["saveFile"]):
			if not tkMessageBox.askyesno("Save", "There is already a game saved, would you like to overwrite it?"):
				return
		saveSettings = settings.copy()
		saveSettings["grid"] = None #GUI objects can't be pickled so must be changed to list format
		saveSettings["hints"] = None
		saveSettings["canvas"] = None
		saveGrid = []
		saveHints = []
		for row in range(0, settings["guesses"]):
			saveGrid.append([])
			saveHints.append([])
			for col in range(0, settings["pegs"]):
				pegColour = canvas.itemcget(settings["grid"][row][col], "fill")
				hintColour = canvas.itemcget(settings["hints"][row][col], "fill")
				saveGrid[row].append(pegColour)
				saveHints[row].append(hintColour)
		f = open("save.dat", "w")
		saveTuple = (saveSettings, saveGrid, saveHints)
		pickle.dump(saveTuple, f)
		f.close()
		tkMessageBox.showinfo("Save", "Game has been saved.")
	else:
		tkMessageBox.showinfo("Save", "The game has finished, there is no need to save.")

def exists(filename):
	fileExists = True
	try:
		f = open(filename, "r")
	except:
		fileExists = False
	return fileExists