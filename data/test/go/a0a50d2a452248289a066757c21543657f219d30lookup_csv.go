package fireflytracker

import (
	"strings"
)

var (
	CSV = `Clustering failure (40 ),Flowcell,Low C1 Intensity / No First Base
CMOS temperature fail (1 ),Flowcell,Temp Sensor Issue
complete computer freeze (1 ),Instrument,Other
computer crash (1 ),Instrument,Other
computer freeze during OBCG (1 ),Instrument,Other
Dead pixel column (1 ),Flowcell,Other
Debris in flowcell (1 ),Flowcell,Surface Abnormality
Failed Paired End (1 ),Chemistry,Other
Failed PE (1 ),Chemistry,Other
failed PE (1 ),Chemistry,Other
failed temperature calibration (1 ),Flowcell,Temp Sensor Issue
Failed to get to temperature (4 ),Flowcell,Temp Sensor Issue
Failed to initialise (1 ),Flowcell,Failed to Initialize/Snap
Failed to snap (3 ),Flowcell,Failed to Initialize/Snap
Failure to pump (1 ),Cartridge,Rotary valve failure
Failure to snap at elevated temp (6 ),Flowcell,Failed to Initialize/Snap
Failure to snap at room temp (2 ),Flowcell,Failed to Initialize/Snap
firmware/CMOS? (1 ),Flowcell,Other
flow and reagent map mismatch (1 ),Cartridge,Rotary valve failure
Flow issue (2 ),Cartridge,Rotary valve failure
Fluidic issues (1 ),Cartridge,Rotary valve failure
Fluidics (1 ),Cartridge,Rotary valve failure
fluidics (3 ),Cartridge,Rotary valve failure
Fluidics failure (1 ),Cartridge,Rotary valve failure
FTS crash (1 ),Software,Other
FTS Error (1 ),Software,Other
FTS error- canceled task (1 ),Software,Other
FTS imaging initalization error (1 ),Software,Other
FTS SW Error (1 ),Software,Other
grafting or clustering flow issue (partially blocked flow) (1 ),Cartridge,Rotary valve failure
Grafting or clustering issue (blocked flow) (1 ),Cartridge,Rotary valve failure
Incorrect CMOS temp (1 ),Flowcell,Temp Sensor Issue
inefficient or inaccurate flow (1 ),Cartridge,Rotary valve failure
Instrument froze twice during run; Python script finally crashed at C46 (1 ),Instrument,Other
Instrument Issue (1 ),Instrument,Other
Leakage (1 ),Instrument,Other
Lid defect (8 ),Flowcell,Other
Lid failure (1 ),Flowcell,Other
Lost flowcell (1 ),Flowcell,Other
MIPI Error (3 ),Flowcell,Other
MIPI error (2 ),Flowcell,Other
No first base (30 ),Flowcell,Low C1 Intensity / No First Base
Paired-end failure (1 ),Flowcell,Other
Passivation Breach (2 ),Flowcell,Passivation Breach
Passivation breach (147 ),Flowcell,Passivation Breach
RTD temperature fail (4 ),Flowcell,Temp Sensor Issue
Reporting negative temperatures when heated (1 ),Flowcell,Temp Sensor Issue
SW Failure (1 ),Software,Other
Software crash (1 ),Software,Other
Surface Defect (29 ),Flowcell,Surface Abnormality
Surface Defect & fuse ID (1 ),Flowcell,Surface Abnormality
User error (1 ),Chemistry,User Error
user error-> temperature control (1 ),Chemistry,User Error
Vertical Lines (1 ),Flowcell,Failed to Initialize/Snap
Vertical Lines for Image (1 ),Flowcell,Failed to Initialize/Snap
vertical lines throughout image? (1 ),Flowcell,Failed to Initialize/Snap
Vertical stripes (1 ),Flowcell,Failed to Initialize/Snap
Wrong CMOS temperature (1ÿ,Flowcell,Temp Sensor Issue
`
)

type migratemap struct {
	oldFailureNote string
	category       string
	newFailureNote string
}

func parseCSV() ([]*migratemap, error) {
	lines := strings.Split(CSV, "\n")

	ret := []*migratemap{}
	for _, ln := range lines {
		tabsplit := strings.Split(ln, `,`)
		if len(tabsplit) < 3 {

			continue
		}
		_oldFailureNote := strings.Split(tabsplit[0], ` (`)
		if len(_oldFailureNote) < 1 {
			slack.Info(tabsplit[0])
			continue
		}

		item := &migratemap{
			oldFailureNote: _oldFailureNote[0],
			category:       tabsplit[1],
			newFailureNote: tabsplit[2],
		}
		ret = append(ret, item)

	}

	return ret, nil
}
