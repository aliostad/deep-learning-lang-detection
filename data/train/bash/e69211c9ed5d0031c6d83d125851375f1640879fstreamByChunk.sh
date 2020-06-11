# This is a test to perform data transfert between a serial port and a bluetooth
# device. For the moment there's some part hardcoded because it's only test purpose
# and you should not use this code anyway.

# this file must be used in conjonction with screen + ctr a then ':' and then write
# command "exec !! ./streamByChunk.sh"

# the offset where to start from the read data
offset=0
# the size of the data to send.
chunkSize=8
dataStream=$(hexdump -s $offset -n $chunkSize -ve '16/1 "%.2x"' /Users/abadie/Desktop/test.gif)

# The transfert need to be feed by chunk, or the serial transfert will not get all the
# input. So here we just basically send chunk of data serially, with each time an
# offset of + chunkSize, then perform a wait because the serial communication may not
# perform as fast as the shell execution.
while [ ${#dataStream} != 0 ]
do
  printf $dataStream | tr [:lower:] [:upper:]

  # need to sleep
  sleep 0.1
  offset=$((offset+chunkSize))
  dataStream=$(hexdump -s $offset -n $chunkSize -ve '1/1 "%.2x"' /Users/abadie/Desktop/test.gif)
done
