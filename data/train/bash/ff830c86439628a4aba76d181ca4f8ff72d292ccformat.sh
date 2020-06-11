#!/bin/sh

files=(sample.tex section1.tex section2.tex section3.tex section4.tex section5.tex section6.tex)
for file in ${files[@]}
do
    sed -i -e "s/。/．/g" $file
    sed -i -e "s/、/，/g" $file
done

export TEXINPUTS=:.//
export BIBINPUTS=:.//
export BSTINPUTS=:.//

mkdir -p tmp
platex -shell-escape -output-directory=tmp sample
pbibtex tmp/sample

sed -i -e "s/: {A forma/{A forma/g" tmp/sample.bbl
sed -i -e "s/: The Coq/The Coq/g" tmp/sample.bbl
rm tmp/sample.bbl-e

platex -shell-escape -output-directory=tmp sample
platex -shell-escape -output-directory=tmp sample
dvipdfmx tmp/sample
