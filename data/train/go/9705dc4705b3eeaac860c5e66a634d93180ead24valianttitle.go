package items

// Звание, необходимое для ношения предмета
type Title int

const (
	Recruit Title = iota
	Soldier
	Fighter
	Warrior
	EliteWarrior
	Champion
	Gladiator
	Commander
	WarSpecialist
	Hero
	WarExpert
	WarMaster
	Executor
	HigherMaster
	Overlord
	LegendaryConqueror
	BattleLord
	Victorious
	Triumphant
	ChosenByGods
)

func (tt *Title) GetTextName(lang string) string {
	if lang == "rus" {
		switch *tt {
		case Recruit:
			return "Рекрут"
		case Soldier:
			return "Солдат"
		case Fighter:
			return "Боец"
		case Warrior:
			return "Воин"
		case EliteWarrior:
			return "Элитный воин"
		case Champion:
			return "Чемпион"
		case Gladiator:
			return "Гладиатор"
		case Commander:
			return "Полководец"
		case WarSpecialist:
			return "Мастер войны"
		case Hero:
			return "Герой"
		case WarExpert:
			return "Военный эксперт"
		case WarMaster:
			return "Магистр войны"
		case Executor:
			return "Вершитель"
		case HigherMaster:
			return "Высший магистр"
		case Overlord:
			return "Повелитель"
		case LegendaryConqueror:
			return "Легендарный завоеватель"
		case BattleLord:
			return "Властелин боя"
		case Victorious:
			return "Победоносец"
		case Triumphant:
			return "Триумфатор"
		case ChosenByGods:
			return "Избранник богов"
		}
	} else {
		switch *tt {
		case Recruit:
			return "Recruit"
		case Soldier:
			return "Soldier"
		case Fighter:
			return "Fighter"
		case Warrior:
			return "Warrior"
		case EliteWarrior:
			return "Elite warrior"
		case Champion:
			return "Champion"
		case Gladiator:
			return "Gladiator"
		case Commander:
			return "Commander"
		case WarSpecialist:
			return "War specialist"
		case Hero:
			return "Hero"
		case WarExpert:
			return "War expert"
		case WarMaster:
			return "War master"
		case Executor:
			return "Executor"
		case HigherMaster:
			return "Higher master"
		case Overlord:
			return "Overlord"
		case LegendaryConqueror:
			return "Legendary conqueror"
		case BattleLord:
			return "Battle lord"
		case Victorious:
			return "Victorious"
		case Triumphant:
			return "Triumphant"
		case ChosenByGods:
			return "Chosen by Gods"
		}
	}
	return "Unknown"
}

