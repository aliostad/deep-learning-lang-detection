import os.path
from Misc import Config as cnf
from Misc import debugPrint as db
from Misc import errorPrint as er
from Misc import normalPrint as pr
from Misc import extractValue

class NetworkLoader:

	def __init__(self):
		self.saveFileVersionName = "VeRx1.0"
		self.saveFileVersionCode = 10
		self.saves = []

	## Update an existing save
	def updateSave(self, network, save):
		foundSave = ["/saveName/", "/notFound/"] 
		
		for existingSave in self.saves:
			if(existingSave[0] == save):
				foundSave = existingSave
		
		# Check if we have found a new save (i.e. foundSave is updated)
		if(foundSave[0] == "/saveName/" and foundSave[1] == "/notFound/"):
			er("Save " + save + " not found, please check your if your save exists")


	def createSave(self, name, network = None):
		if(not cnf.useSaveFile):
			er("You are trying to create a save while saves are disabled, enable saving by running 'NetworkLoader.enableSaves()'")
			return

		# Check if directory exists, and make one if not
		if(not os.path.isdir("saves")):
			os.makedirs("saves/")
			specificSaveFile = open("saves/"+name, 'ab+')
		
		saveFile = open('saveFile', 'ab+')

		while(saveFile.read().find("save:"+name) != -1):
			er("Save already exists.")
			newName = raw_input("Please input a new name: ")
			name = str(newName)

		specificSaveFile = open('saves/'+name, 'ab+')

		saveFile.write("\nsave:"+name +" = " + "\"saves/"+name+"\"")
		saveFile.close()

		# We have a network we need to save
		if(network != None):
			lol = False


	def enableSaves(self):
		if(cnf.useSaveFile):
			pr("Saves are already enabled")
		else:
			cnf.useSaveFile = True

	# Loads a save and returns the relevant network
	def loadSave(self, id):
		return self.saves[id]

	def checkForPossibleSaves(self):
		# Open file
		db("Checking for saves")
		if(not os.path.isfile('saveFile')): 
			ans = raw_input("You dont have a saveFile, do you want to make one(y/n)? ")
			if(ans.lower() == "y"):
				f = open('saveFile', 'w+')
				f.write("# Declare version\nmeta:version = " + self.saveFileVersionName +"\n\n")
				f.write("# Save counter\nmeta:counter = " + str(0) +"\n\n")
				f.write("# Saves\n# Example:\n#save:savename = savedir/savefilename")
				f.close()
			else:
				cnf.useSaveFile = False
			return 

		saveFile = open('saveFile', 'r')

		saveFileContent = saveFile.read()
		commentLines = []

		# Remove comment-lines from saveFileContent
		index = saveFileContent.find("#")
		while(index != -1):
			newLineIndex = saveFileContent.find("\n", index)

			# End of file has been reached
			if(newLineIndex == -1):
				commentLines.append(saveFileContent[index:])
			else:
				commentLines.append(saveFileContent[index:newLineIndex])

			index = saveFileContent.find("#", newLineIndex)

		# Remove commentlines
		for line in commentLines:
			saveFileContent = saveFileContent.replace(line, "")

		# Find version
		version = extractValue(saveFileContent, "meta:version")

		if(version == cnf.notFoundHash):
			er("Could not find meta:version in the saveFile. Please manually add: " + self.saveFileVersionName)
		elif(version == cnf.errorHash):
			er("Something went wrong while looking for meta:version...")

		if(not version == self.saveFileVersionName):
			try:
				verId = int(version.replace(".", "").split("x")[1])
				if(verId > self.saveFileVersionCode):
					er("saveFile's version is ahead of yours, perhaps its time to udpate?")
				else:
					er("saveFile's version is outdated, do you want to update it?")
					answer = raw_input("(y/n): ")
					if(answer.lower() == "y"):
						db("Updating saveFile...")
						#TODO
					else:
						pr("Working with outdated saveFile, errors might occur.")
			except:
				er("Illformatted version? Version should be: " + str(self.saveFileVersionCode))

		# No more operations to do on file, we can close it
		saveFile.close()

		# Find count
		saveCount = extractValue(saveFileContent, "meta:count")

		if(saveCount == cnf.notFoundHash):
			er("Could not find meta:count in saveFile. Please add one reflecting the amount of saves in the saveFile")
		elif(saveCount == cnf.errorHash):
			er("Something went wrong while looking for meta:count...")

		try:
			saveCount = int(saveCount)
		except:
			er("Is meta:count not an integer?")

		db(str(saveCount))

		# Find saves
		nextIndex = 0
		while(saveFileContent.find("save:", nextIndex) != -1):
			index = saveFileContent.find("save:", nextIndex)
			saveName = saveFileContent[index+5 : saveFileContent.find(" ", index)]
			saveValue = extractValue(saveFileContent, "save:", index)
		
			db("Save found!")
			db(saveName)
			db(saveValue)
			
			self.saves.append([saveName, saveValue.replace("\"", "")])
			nextIndex = index + 1 

		# Check for default file
		default = extractValue(saveFileContent, "meta:defaultNetwork")

		if(default != cnf.notFoundHash):
			answer = raw_input("Default network is " + default + ". Do you want to load it(y/n)?")
			
			# Load default save
			if(answer.lower() == "y"):
				return [i[0] for i in self.saves].index("Tormod")


		# Ask if anything should be loaded
		if(len(self.saves) == 0):
			return None
		else:
			pr("Save content found:\n----------------")
			i = 1
			for tuple in self.saves:
				print '['+str(i)+'] {0}\t:\t{1}'.format(tuple[0], tuple[1])
				i = i+1
			ans = raw_input("Do you want to load anything right now (LoadNr / n)?")
			if(str(ans) == "n"):
				return -1

			# Check if number is outside the bounds, or is not an integer
			while(True):
				try:
					ans = int(ans)
				except:
					ans = raw_input("Invalid load-value, try again: ")
					continue

				if(ans >= i or ans < 1):
					ans = raw_input("Invalid load-value, try again: ")
					continue
				else:
					break
			return loadSave(ans-1)
		return None