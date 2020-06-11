#!/bin/sh
#-------------------------------------------------------------------------
# Splitting quads by number of triples.
##########################################################################

# usage message
usage() {
cat << EOF
usage: $0 options [quad_file.gz [...]]

OPTIONS:
   -h      Show this message
   -d      Set the target directory (default: "split")
   -n      Number of triples per chunk
   -p      Prefix for chunks (default: "chunk-")
EOF
}

TCOUNT=10000000;
DSTDIR="split"
PREFIX="chunk-"

# parse arguments
while getopts "hd:n:p:" OPTION; do
  case $OPTION in
    h) usage; exit 1 ;;
    d) DSTDIR=$OPTARG ;;
    n) TCOUNT=$OPTARG ;;
    p) PREFIX=$OPTARG ;;
  esac
done
shift $(( OPTIND-1 )) # shift consumed arguments

echo "splitting data in $TCOUNT triples per chunk. writing chunks to '$DSTDIR'" >&2;

# check if output directory exists
if [ ! -d "$DSTDIR" ]; then
  echo Error: directory \'$DSTDIR\' not found
  exit
fi

# handle all files from argument list
echo "processing $# files..." >&2;
for i in $@; do

  echo `date +%X` "$i" >&2;
  gzip -dc $i | perl -slne '
  if ($countdown-- == 0) {
    close FILE if ($chunk);
    $name = sprintf("$prefix%03d.gz", $chunk++);
    # TODO: check if chunkfile already exists
    open FILE, "| gzip >>$dir/$name" or die "ERROR: cannot save file $dir/$name.gz: $!";
    $time = `date +%X`; chomp($time);
    print STDERR "$time $name [".($.-1)." total]";
    $countdown = $count-1;
  }
  print FILE $_;
  END { close FILE }' -- -dir=$DSTDIR -count=$TCOUNT -prefix=$PREFIX
done

echo `date +%X` "done" >&2;
