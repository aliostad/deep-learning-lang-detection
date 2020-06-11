package lib

import (
	"bufio"
	"encoding/binary"
	"errors"
)

func Readln(r *bufio.Reader) (string, error) {
	// http://stackoverflow.com/a/12206584
	// http://stackoverflow.com/a/21124415
	// http://stackoverflow.com/a/16615559
	//
	// Example:
	//
	// ```
	// reader := bufio.NewReaderSize(fp, 128 * 1024)  // 128KB
	//
	// line, err := Readln(reader)
	// for err == nil {
	//     fmt.Println(line)
	//     line, err = Readln(reader)
	// }
	// ```

	var (
		isPrefix         bool  = true
		err              error = nil
		line, ln         []byte
		num_buffer_count = 0
	)
	for isPrefix && err == nil {
		line, isPrefix, err = r.ReadLine()
		ln = append(ln, line...)

		num_buffer_count += 1
		if num_buffer_count > 10 {
			err = errors.New("too long line")
			break
		}
	}
	return string(ln), err
}

func Itob(v int64) []byte {
	// https://github.com/boltdb/bolt
	b := make([]byte, 8)
	binary.BigEndian.PutUint64(b, uint64(v))
	return b
}

func ChromToId(chrom string) int64 {
	switch chrom {
	case "1":
		return 1
	case "2":
		return 2
	case "3":
		return 3
	case "4":
		return 4
	case "5":
		return 5
	case "6":
		return 6
	case "7":
		return 7
	case "8":
		return 8
	case "9":
		return 9
	case "10":
		return 10
	case "11":
		return 11
	case "12":
		return 12
	case "13":
		return 13
	case "14":
		return 14
	case "15":
		return 15
	case "16":
		return 16
	case "17":
		return 17
	case "18":
		return 18
	case "19":
		return 19
	case "20":
		return 20
	case "21":
		return 21
	case "22":
		return 22
	case "X":
		return 23
	case "Y":
		return 24
	case "M":
		return 25
	case "MT":
		return 25

	case "chr1":
		return 1
	case "chr2":
		return 2
	case "chr3":
		return 3
	case "chr4":
		return 4
	case "chr5":
		return 5
	case "chr6":
		return 6
	case "chr7":
		return 7
	case "chr8":
		return 8
	case "chr9":
		return 9
	case "chr10":
		return 10
	case "chr11":
		return 11
	case "chr12":
		return 12
	case "chr13":
		return 13
	case "chr14":
		return 14
	case "chr15":
		return 15
	case "chr16":
		return 16
	case "chr17":
		return 17
	case "chr18":
		return 18
	case "chr19":
		return 19
	case "chr20":
		return 20
	case "chr21":
		return 21
	case "chr22":
		return 22
	case "chrX":
		return 23
	case "chrY":
		return 24
	case "chrM":
		return 25
	case "chrMT":
		return 25

	default:
		panic("unrecognized chrom string")
	}
}

func ChrPos(chrom string, pos int64) int64 {
	return ChromToId(chrom) * 1000000000 + pos
}
