package netrcutil

import (
	"fmt"
	"path/filepath"

	"github.com/bitrise-io/go-utils/fileutil"
	"github.com/bitrise-io/go-utils/pathutil"
)

const netrcDefaultFileName = ".netrc"

// NetRCItemModel ...
type NetRCItemModel struct {
	Machine  string
	Login    string
	Password string
}

// NetRCModel ...
type NetRCModel struct {
	OutputPth  string
	ItemModels []NetRCItemModel
}

// New ...
func New() *NetRCModel {
	netRCPth := filepath.Join(pathutil.UserHomeDir(), netrcDefaultFileName)
	return &NetRCModel{OutputPth: netRCPth}
}

// AddItemModel ...
func (netRCModel *NetRCModel) AddItemModel(itemModels ...NetRCItemModel) {
	netRCModel.ItemModels = append(netRCModel.ItemModels, itemModels...)
}

// CreateFile ...
func (netRCModel *NetRCModel) CreateFile() error {
	netRCFileContent := generateFileContent(netRCModel)
	return fileutil.WriteStringToFile(netRCModel.OutputPth, netRCFileContent)
}

// Append ...
func (netRCModel *NetRCModel) Append() error {
	netRCFileContent := generateFileContent(netRCModel)
	return fileutil.AppendStringToFile(netRCModel.OutputPth, fmt.Sprintf("\n\n%s", netRCFileContent))
}

func generateFileContent(netRCModel *NetRCModel) string {
	netRCFileContent := ""
	for i, itemModel := range netRCModel.ItemModels {
		netRCFileContent += fmt.Sprintf("machine %s\nlogin %s\npassword %s", itemModel.Machine, itemModel.Login, itemModel.Password)
		if i != len(netRCModel.ItemModels)-1 {
			netRCFileContent += "\n\n"
		}
	}
	return netRCFileContent
}
