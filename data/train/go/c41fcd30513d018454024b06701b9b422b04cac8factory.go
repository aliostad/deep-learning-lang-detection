package model

import (
	"github.com/motain/gorp"
	_ "github.com/motain/mysql"
)

type (
	Manager struct {
		DbMap *gorp.DbMap
	}

	CountryManager struct {
		Manager
	}

	SectionManager struct {
		Manager
	}

	CompetitionManager struct {
		Manager
	}

	TopCompetitionManager struct {
		Manager
	}
)

func GetCountryManager(dbMap *gorp.DbMap) *CountryManager {
	return &CountryManager {
			Manager { DbMap: dbMap },
	}
}

func GetSectionManager(dbMap *gorp.DbMap) *SectionManager {
	return &SectionManager {
		Manager { DbMap: dbMap },
	}
}

func GetCompetitionManager(dbMap *gorp.DbMap) *CompetitionManager {
	return &CompetitionManager {
		Manager { DbMap: dbMap },
	}
}

func GetTopCompetitionManager(dbMap *gorp.DbMap) *TopCompetitionManager {
	return &TopCompetitionManager {
		Manager { DbMap: dbMap },
	}
}
