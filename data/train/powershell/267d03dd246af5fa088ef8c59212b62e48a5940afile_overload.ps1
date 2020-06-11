param (
  [string]$PATH,
  [string]$NUMFILES
)
new-item "$PATH\nested" -itemtype directory

$FILES=@("test_files/testImage.jpg", "test_files/testVideo.mp4", "test_files/testWordDoc.doc" )

for ($i=1; $i -lt $NUMFILES; $i++) {
  $FILENAME="file$i.ext(Richie's conflicted copy 2015-09-08).sookasa"
  ForEach ($ITEM in $FILES) {
    copy $ITEM "$PATH/$FILENAME"
  }
}

for ($i=1; $i -lt $NUMFILES; $i++) {
  $FILENAME="file$i.ext(Richie's conflicted copy 2015-09-08).sookasa"
 ForEach ($ITEM in $FILES) {
    copy $ITEM "$PATH/nested/$FILENAME"
  }
}