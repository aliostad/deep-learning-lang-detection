/**
 * @file
 * @brief Load Manager
 * @author project.kuto
 */
#pragma once

#include <string>
#include "kuto_static_vector.h"
#include "kuto_task_singleton.h"

namespace kuto {

class LoadCore;

/// Load Manager Class
class LoadManager : public TaskSingleton<LoadManager>
{
	friend class TaskSingleton<LoadManager>;
public:
	LoadCore* searchLoadCore(const std::string& filename, const char* subname);
	void addLoadCore(LoadCore* core);
	void releaseLoadCore(LoadCore* core);

protected:
	LoadManager();
	virtual ~LoadManager();

	virtual void update();

private:
	/// LoadCoreのリスト
	typedef StaticVector<LoadCore*, 256> LoadCoreList;

private:
	LoadCoreList		coreList_;			///< LoadCoreリスト
	bool				eraseCoreFlag_;		///< LoadCoreでeraseするものがあるよフラグ
};	// class LoadManager

}	// namespace kuto
