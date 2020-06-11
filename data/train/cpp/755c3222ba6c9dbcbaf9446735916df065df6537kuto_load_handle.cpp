/**
 * @file
 * @brief Load Handle
 * @author project.kuto
 */

#include "kuto_load_handle.h"
#include "kuto_load_core.h"
#include "kuto_load_manager.h"

#include "AppMain.h"


namespace kuto {

LoadHandle::LoadHandle()
: core_(NULL)
{
}

LoadHandle::~LoadHandle()
{
	if (core_)
		release();
}

bool LoadHandle::load(const std::string& filename, const char* subname)
{
	if (core_)
		release();
	core_ = LoadManager::instance().searchLoadCore(filename, subname);
	if (!core_) {
		core_ = createCore(filename, subname);
		LoadManager::instance().addLoadCore(core_);
	}
	return core_ != NULL;
}

void LoadHandle::release()
{
	if (core_ /* && LoadManager::instance() */)
		LoadManager::instance().releaseLoadCore(core_);
	core_ = NULL;
}

const std::string& LoadHandle::filename() const
{
	if (core_)
		return core_->filename();
	static std::string NOT_LOADED("(not loaded)");
	return NOT_LOADED;
}

u32 LoadHandle::crc() const
{
	if (core_)
		return core_->crc();
	return 0;
}

}	// namespace kuto
