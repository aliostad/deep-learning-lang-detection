import "bytes"

func intToRoman(num int) string {
    integers := [7]int{1, 5, 10, 50, 100, 500, 1000};
    roman := [7]byte{'I', 'V', 'X', 'L', 'C', 'D', 'M'};
    var result bytes.Buffer;
    var count [7]int;
    var tmp int;
    
    tmp = num;
    for i := 6; i > -1; i -= 2 {
        count[i] = tmp / integers[i];
        tmp -= integers[i] * count[i];
    }
    
    tmp = num;
    for i := 0; i < count[6]; i++ {
        result.WriteByte(roman[6]);
        tmp -= integers[6];
    }
    
    for i := 4; i > -1; i -= 2 {
        switch count[i] {
            case 0:
                continue;
            case 1:
                result.WriteByte(roman[i]);
            case 2:
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i]);
            case 3:
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i]);
            case 4:
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i+1]);
            case 5:
                result.WriteByte(roman[i+1]);
            case 6:
                result.WriteByte(roman[i+1]);
                result.WriteByte(roman[i]);
            case 7:
                result.WriteByte(roman[i+1]);
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i]);
            case 8:
                result.WriteByte(roman[i+1]);
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i]);
            case 9:
                result.WriteByte(roman[i]);
                result.WriteByte(roman[i+2]);
        }
    }
    
    return result.String();
}
