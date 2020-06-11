rm -f 1000.in
rm -f 10000.in
rm -f 100000.in
rm -f 1000000.in

for i in {1..1000000}
do
  if [ "$i" -lt 1000 ]
  then
    echo "C o$i $i $i 10" >> 1000.in
  fi
  if [ "$i" -lt 10000 ]
  then
    echo "C o$i $i $i 10" >> 10000.in
  fi
  if [ "$i" -lt 100000 ]
  then
    echo "C o$i $i $i 10" >> 100000.in
  fi
  echo "C o$i $i $i 10" >> 1000000.in
done

echo "SAVE 1000.save" >> 1000.in
echo "SAVE 10000.save" >> 10000.in
echo "SAVE 100000.save" >> 100000.in
echo "SAVE 1000000.save" >> 1000000.in

echo "CLEAR" >> 1000.in
echo "CLEAR" >> 10000.in
echo "CLEAR" >> 100000.in
echo "CLEAR" >> 1000000.in

echo "LOAD 1000.save" >> 1000.in
echo "LOAD 10000.save" >> 10000.in
echo "LOAD 100000.save" >> 100000.in
echo "LOAD 1000000.save" >> 1000000.in
