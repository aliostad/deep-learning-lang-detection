#!/bin/sh

# This script lists all model files for a given model.
# Sub-models can be specified after a /
#
# Examples:
#
#   ./list_sarah_model_files.sh MSSM
#   ./list_sarah_model_files.sh MSSM/CKM

if test $# -ne 1; then
    echo "Error: 1 argument required"
    echo "Usage: $0 <sarah-model-name>[/<sub-model>]"
    echo ""
    echo "Examples:"
    echo ""
    echo "   $0 MSSM"
    echo "   $0 MSSM/CKM"
    exit 1
fi

OPERATING_SYSTEM="Linux"

convert_dos_paths() {
    case "$OPERATING_SYSTEM" in
    CYGWIN_NT*) xargs -d \  cygpath ;;
    *)          cat ;;
    esac
}

# directory of this script
BASEDIR=$(dirname $0)

FLEXIBLESUSY_SARAH_DIR="${BASEDIR}/../sarah"

model="$1"

cat <<EOF | ("math" 2> /dev/stdout 1> /dev/null) | convert_dos_paths
FindModelFiles[dir_String, modelName_String, submodeldir_] :=
    Module[{files, modelFile, modelDir},
           If[submodeldir =!= False,
              modelDir  = FileNameJoin[{dir, modelName, submodeldir}];
              modelFile = FileNameJoin[{modelDir, modelName <> "-" <> submodeldir <> ".m"}];
              ,
              modelDir  = FileNameJoin[{dir, modelName}];
              modelFile = FileNameJoin[{modelDir, modelName <> ".m"}];
             ];
           files = Join[{modelFile},
                        FileNameJoin[{modelDir, #}]& /@ {"parameters.m", "particles.m"}
                       ];
           Select[files, FileExistsQ]
          ];

sarahLoaded = Needs["SARAH\`"];

If[sarahLoaded === \$Failed || !ValueQ[\$sarahModelDir],
   Quit[1];
  ];

If[!StringFreeQ["${model}","/"],
   splitted = StringSplit["${model}","/"];
   modelName = splitted[[1]];
   submodeldir = splitted[[2]];
   ,
   modelName = "${model}";
   submodeldir = False;
];

(* search in SARAH/Models/ directory *)
files = FindModelFiles[\$sarahModelDir, modelName, submodeldir];

(* search in FlexibleSUSY/sarah/ directory *)
If[files === {},
   files = FindModelFiles["${FLEXIBLESUSY_SARAH_DIR}", modelName, submodeldir];
  ];

strList = "";
For[i = 1, i <= Length[files], i++,
    If[i > 1, strList = strList <> " ";];
    strList = strList <> files[[i]];
   ];

WriteString["stderr", strList];

Quit[];
EOF
