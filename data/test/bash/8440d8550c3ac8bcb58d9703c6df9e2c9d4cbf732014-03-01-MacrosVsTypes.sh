#!/usr/bin/env bash
NESCALA_REPO="/Users/xeno_by/Projects/nescala2014"
THIS_REPO="$(dirname "$0")"

if [[ -d "$THIS_REPO/img" ]]; then rm -rf "$THIS_REPO/img"; fi
if [[ -f "$THIS_REPO/beamerthemenescala.sty" ]]; then rm -f "$THIS_REPO/beamerthemenescala.sty"; fi
if [[ -f "$THIS_REPO/2014-03-01-MacrosVsTypes.tex" ]]; then rm -rf "$THIS_REPO/2014-03-01-MacrosVsTypes.tex"; fi

cp -r "$NESCALA_REPO/img" "$THIS_REPO/img"
cp "$NESCALA_REPO/beamerthemenescala.sty" "$THIS_REPO/beamerthemenescala.sty"
cp "$NESCALA_REPO/2014-03-01-MacrosVsTypes.tex" "$THIS_REPO/2014-03-01-MacrosVsTypes.tex"

#cp "$NESCALA_REPO/2014-03-01-MacrosVsTypes.pdf" "$THIS_REPO/2014-03-01-MacrosVsTypes.pdf"
cd "$THIS_REPO"
xelatex "$THIS_REPO/2014-03-01-MacrosVsTypes.tex" && xelatex "$THIS_REPO/2014-03-01-MacrosVsTypes.tex"
