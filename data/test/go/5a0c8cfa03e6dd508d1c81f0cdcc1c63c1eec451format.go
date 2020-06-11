package input

import (
  "fmt"
  "strings"
  "path/filepath"
)

func Load (localfile string) (map[string][]interface{}, error) {
  fmt.Println("Loading", localfile)
  extension := strings.ToLower(filepath.Ext(localfile))
  switch extension {
    case ".jsond":
      return LoadJSOND(localfile)
    case ".csv":
      return LoadCSV1(localfile, ',')
    case ".psv":
      return LoadCSV2(localfile, "|")
    case ".tsv":
      return LoadCSV2(localfile, "\t")
    default:
      return LoadJSON(localfile)
  }
}
