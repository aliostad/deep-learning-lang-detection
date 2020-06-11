#ifndef RESOURCE_LOAD_COMMAND_H
#define RESOURCE_LOAD_COMMAND_H

#include "PN/Command/Command.h"

#include "PN/Util/ResourceManager.h"
#include "PN/Util/PString.h"

namespace pn {
	class ResourceLoadCommand : public pn::Command {
	public:
		ResourceLoadCommand(ResourceManager* resourceManager, const PString& fileToLoad) : m_resourceManager(resourceManager),
			m_fileToLoad(fileToLoad) {}

		void execute() override {
			m_resourceManager->load(m_fileToLoad);
		}

	private:
		ResourceManager* m_resourceManager;
		PString m_fileToLoad;
	};
}

#endif