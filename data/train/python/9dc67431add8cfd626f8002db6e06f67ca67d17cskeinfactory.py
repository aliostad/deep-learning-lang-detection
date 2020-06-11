#!/usr/bin/python

import __init__

from fabmetheus_utilities import gcodec
from fabmetheus_utilities import settings
from skeinforge_application import skeinforge
import skeinforge_plugins
import Tkinter

def forwardDeclartions():
	"Force some functions to be dynamic"
	mockRepository = settings.Repository()
	settings.addListsToRepository(None, None, mockRepository)
	settings.cancelRepository(mockRepository)
	settings.getDisplayedDialogFromConstructor(mockRepository)
	settings.getProfileBaseName(mockRepository)
	settings.getReadRepository(mockRepository)
	settings.readSettingsFromText(mockRepository, '')
	settings.saveRepository(mockRepository)
	settings.startMainLoopFromConstructor(mockRepository)
	settings.writeSettings(mockRepository)
	settings.writeSettingsPrintMessage(mockRepository)
	settings.StringSetting().getFromValue('', mockRepository, '')
	settings.StringSetting().getFromValueOnly('', mockRepository, '')
	settings.StringSetting().getFromValueOnlyAddToRepository('', mockRepository, '')
	settings.FileNameInput().getFromFileName([('','')], '', mockRepository, '')
	settings.GridVertical(0, 0).setExecutablesRepository(mockRepository)
	settings.HelpPage().setToNameRepository('', mockRepository)
	settings.HelpPage().getFromNameAfterWWW('', '', mockRepository)
	settings.HelpPage().getFromNameAfterHTTP('', '', mockRepository)
	settings.HelpPage().getFromNameSubName('', mockRepository, '')
	settings.HelpPageRepository.__init__(settings.HelpPageRepository(), mockRepository)
	settings.LabelDisplay().getFromName('', mockRepository)
	settings.LabelSeparator().getFromRepository(mockRepository)
	settings.MenuButtonDisplay().getFromName('', mockRepository)
	settings.Radio().getFromRadio(None, '', mockRepository, False)
	settings.WindowPosition().getFromValue(mockRepository, '')
	settings.RepositoryDialog(mockRepository, None).addButtons(mockRepository, None)
	settings.RepositoryDialog.__init__(RepositoryDialog(), mockRepository, None)
	gcodec.Plugins.add(settings.Plugin())
	Tkinter.Button.__init__(None, {})

def main():
	if False:
		forwardDeclartions()

	skeinforge_plugins.add_all()
	skeinforge.main()

if __name__ == "__main__":
	main()
