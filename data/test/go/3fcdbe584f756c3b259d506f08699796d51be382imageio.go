// This module provides routines for writing PGM/PBM images in Go.
// Owain Kenway

package pnmmodules

import ("os"
        "strconv"
)

// Function to handle errors.
func chkerr(err error) {
    if err != nil {
        panic(err)
    }  
}

// Write a pgm file from 2D slice d.
// white - the value of white (max value).
// filename - the file to write to.
func Writepgm(d [][]int, white int, filename string) {
    var x, y, i, j int
    x = len(d)
    y = len(d[0])

// Open file and make sure we have no errors.
    file, err:= os.Create(filename)
    chkerr(err)

    defer file.Close()

// Write PGM header.
    file.WriteString("P2\n")
    file.WriteString("# Written by pnmmodules (https://github.com/owainkenwayucl/pnmmodules).\n")
    file.WriteString(strconv.Itoa(x))
    file.WriteString(" ")
    file.WriteString(strconv.Itoa(y))
    file.WriteString("\n")
    file.WriteString(strconv.Itoa(white))
    file.WriteString("\n")

// Write out d.
    for j = 0; j < y; j++ {
        for i = 0; i < x; i++ {        
            file.WriteString(strconv.Itoa(d[i][j]))
            file.WriteString("\n")
        }
    }

// Tidy up.
    file.Sync()
}

// Write a pbm file from 2D slice d.
// threshold - the value at which 0 becomes 1.
// filename - the file to write to.
func Writepbm(d [][]int, threshold float64, filename string) {
    var x, y, i, j int
    x = len(d)
    y = len(d[0])

// Open file and make sure we have no errors.
    file, err:= os.Create(filename)
    chkerr(err)

    defer file.Close()

// Write PBM header.
    file.WriteString("P1\n")
    file.WriteString("# Written by pnmmodules (https://github.com/owainkenwayucl/pnmmodules).\n")
    file.WriteString(strconv.Itoa(x))
    file.WriteString(" ")
    file.WriteString(strconv.Itoa(y))
    file.WriteString("\n")

// Write out d.
    for j = 0; j < y; j++ {
        for i = 0; i < x; i++ {        
            if float64(d[i][j]) >= threshold {
                file.WriteString("1\n")                
            } else {
                file.WriteString("0\n")
            }
        }
    }

// Tidy up.
    file.Sync()
}