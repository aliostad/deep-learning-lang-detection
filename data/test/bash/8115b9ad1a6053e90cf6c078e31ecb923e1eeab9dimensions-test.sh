#!/usr/bin/env roundup

describe "dimensions: Python lib to read the height and with of image files"

before() {
    cd ../bin
}

after() {
    cd ../tests
}

dimensions="./dimensions"

it_shows_help_with_no_argv() {
  $dimensions 2>&1 | grep -i USAGE
}

it_reads_gifs() {
  gif="$($dimensions ../sample/sample.gif)"
  test "$gif" = "../sample/sample.gif
  width: 250
  height: 297
  content-type: image/gif"
}

it_reads_pngs() {
  png="$($dimensions ../sample/sample.png)"
  test "$png" = "../sample/sample.png
  width: 405
  height: 239
  content-type: image/png"
}

it_reads_jpegs() {
  jpeg="$($dimensions ../sample/sample.jpg)"
  test "$jpeg" = "../sample/sample.jpg
  width: 313
  height: 234
  content-type: image/jpeg"
}
