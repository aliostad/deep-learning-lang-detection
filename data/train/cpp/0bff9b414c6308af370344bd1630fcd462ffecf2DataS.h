//Copyright © 2014 (´･@･)
//[License]GNU Affero General Public License, version 3
//[Contact]http://tacoika.blog87.fc2.com/
#pragma once

#include "UnitData.h"
#include "WitchData.h"
#include "EnemyData.h"
#include "StageData.h"
#include "DifficultyData.h"
#include "ChipData.h"
#include "RecordData.h"
#include "HelpData.h"
namespace SDX_TD
{
	using namespace SDX;
	void LoadDataS()
	{
		LoadUnitS();
		LoadEnemyS();
		LoadStageS();
		LoadWitchS();
		LoadDifficultyS();
		LoadChipS();
		LoadRecordS();
		LoadHelpS();
	}
}