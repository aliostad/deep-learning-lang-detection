package main

import "fmt"

func main() {
	g := &game{
		turnPhase: "corporation-1.1",
		corporation: corporation{
			identity: cardJintekiPersonalEvolution,
			clicks:   3,
			deck: []card{
				cardNiseiMKII,
				cardProjectJunebug,
				cardSnare,
				cardZaibatsuLoyalty,
				cardNeuralEMP,
				cardPrecognition,
				cardCellPortal,
				cardChum,
				cardDataMine,
				cardNeuralKatana,
				cardWallOfThorns,
				cardAkitaroWatanabe,
				cardPriorityRequisition,
				cardPrivateSecurityForce,
				cardMelangeMiningCorp,
				cardPADCampaign,
				cardHedgeFund,
				cardEnigma,
				cardHunter,
				cardWallOfStatic,
			},
			servers: []server{
				{
					t:    "R&D",
					root: []serverCard{},
					ice:  []serverCard{},
				},
				{
					t:    "Archives",
					root: []serverCard{},
					ice:  []serverCard{},
				},
				{
					t:    "HQ",
					root: []serverCard{},
					ice:  []serverCard{},
				},
			},
		},
		runner: runner{
			identity: "Gabriel Santiago: Consummmate Professional",
			deck: []string{
				"Account Siphon",
				"Easy Mark",
				"Forged Activation Orders",
				"Inside Job",
				"Special Order",
				"Lemuria Codecracker",
				"Desperado",
				"Aurora",
				"Femme Fatale",
				"Ninja",
				"Sneakdoor Beta",
				"Bank Job",
				"Crash Space",
				"Data Dealer",
				"Decoy",
				"Infiltration",
				"Sure Gamble",
				"Crypsis",
				"Access to Globalsec",
				"Armitage Codebusting",
			},
		},
	}
	g.dispatch(corporationDraw{clickCost: 0, numCards: 5})
	g.dispatch(runnerDraw{clickCost: 0, numCards: 5})
	g.dispatch(gainCredits{corporation: 5, runner: 5})
	g.dispatch(corporationInstallNewRemote{handIndex: 0})
	g.dispatch(corporationAdvanceCard{serverIndex: 3, location: "root", locationIndex: 0})
	g.dispatch(corporationAdvanceCard{serverIndex: 3, location: "root", locationIndex: 0})
	fmt.Println(g)
	g.dispatch(runnerTurn(4))
	fmt.Println(g)
}

type actioner interface {
	action(*game) *game
}

type gainCredits struct {
	corporation int
	runner      int
}

func (gc gainCredits) action(g *game) *game {
	g.corporation.credits += gc.corporation
	g.runner.credits += gc.runner
	return g
}

type corpTurnBegin struct{}

func (c corpTurnBegin) action(g *game) *game {
	g.turnPhase = "corporation-1.2"
	return g
}

type runnerTurnBegin struct{}

func (r runnerTurnBegin) action(g *game) *game {
	g.turnPhase = "runner-1.2"
	return g
}

type game struct {
	corporation
	runner
	turnPhase string
}

func (g *game) dispatch(a actioner) {
	g = a.action(g)
}

type serverCard struct {
	rezzed            bool
	advancementTokens int
	virusCounters     int
	card
}

type server struct {
	t    string
	ice  []serverCard
	root []serverCard
}

type corporation struct {
	identity card
	clicks   int
	credits  int
	deck     []card
	hand     []card
	servers  []server
}

type runner struct {
	identity  string
	clicks    int
	credits   int
	deck      []string
	hand      []string
	programs  []string
	hardware  []string
	resources []string
}
