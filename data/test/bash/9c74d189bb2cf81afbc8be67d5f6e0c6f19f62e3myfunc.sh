

fname()
{
	echo "\$1,\$2=$1,$2";
	echo "\$@=$@";
	echo "\$*=$*"
	return 0;
}
fname "age" "address" "sex";
echo "we usually used \$@ to list args."

echo 
printFileNameAndExtension()
{
	file_sample="sample.book.txt.jpg"
	name=${file_sample%.*}
	nameGreedy=${file_sample%%.*}
	extension=${file_sample#*.}
	extensionGreedy=${file_sample##*.}
	echo "the name of file sample.book.txt.jpg is $name"
	echo "the greedy name of file sample.book.txt.jpg is $nameGreedy"
	echo "the extension of file sample.book.txt.jpg is $extension"
	echo "the greedy extension of file sample.book.txt.jpg is $extensionGreedy"
}
printFileNameAndExtension

