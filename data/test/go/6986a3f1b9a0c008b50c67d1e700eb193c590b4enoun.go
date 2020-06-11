package noun

import (
	"encoding/json"
	"fmt"
	"github.com/marthjod/binquiry/model/case"
	"github.com/marthjod/binquiry/model/gender"
	"github.com/marthjod/binquiry/model/number"
	"github.com/marthjod/binquiry/model/wordtype"
	"gopkg.in/xmlpath.v2"
)

// CaseForm represents a single case form, i.e. case name, number, and actual form.
type CaseForm struct {
	Case   cases.Case    `json:"case"`
	Number number.Number `json:"number"`
	Form   string        `json:"form"`
}

// Noun is defined as a combination of a gender and a list of case forms.
type Noun struct {
	Type      wordtype.WordType `json:"type"`
	Gender    gender.Gender     `json:"gender"`
	CaseForms []CaseForm        `json:"cases"`
}

// ParseNoun parses XML input into a Noun struct.
func ParseNoun(header string, iter *xmlpath.Iter) *Noun {
	n := Noun{
		Type:   wordtype.Noun,
		Gender: gender.GetGender(header),
	}
	counter := 1
	for iter.Next() {
		node := iter.Node()
		switch counter {
		case 1:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Nominative,
				Number: number.Singular,
				Form:   node.String(),
			})
		case 2:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Accusative,
				Number: number.Singular,
				Form:   node.String(),
			})
		case 3:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Dative,
				Number: number.Singular,
				Form:   node.String(),
			})
		case 4:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Genitive,
				Number: number.Singular,
				Form:   node.String(),
			})
		case 5:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Nominative,
				Number: number.Plural,
				Form:   node.String(),
			})
		case 6:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Accusative,
				Number: number.Plural,
				Form:   node.String(),
			})
		case 7:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Dative,
				Number: number.Plural,
				Form:   node.String(),
			})
		case 8:
			n.CaseForms = append(n.CaseForms, CaseForm{
				Case:   cases.Genitive,
				Number: number.Plural,
				Form:   node.String(),
			})
		}
		counter++
	}

	return &n
}

// JSON representation of a Noun.
func (n *Noun) JSON() string {
	j, err := json.MarshalIndent(n, "", "  ")
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}
	return string(j)
}
