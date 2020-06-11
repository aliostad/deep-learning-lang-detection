import util

SAVE_MAX = 255

class PNM:
#    def save(filename, data):
#        f = open(filename, "w")
#        f.write("P3\n%d %d\n%d\n" % (len(data[0]), len(data), SAVE_MAX))
#        for row in data:
#            for c in row:
#                x = round(SAVE_MAX*c)
#                f.write("%d %d %d\n" %(x,x,x))
#    save = staticmethod(save)
                
    def saveColor(filename, data, colorScheme):
        f = open(filename, "w")
        f.write("P3\n%d %d\n%d\n" % (len(data[0]), len(data), SAVE_MAX))
        for row in data:
            for c in row:
                if (c < 0):
                    c = 0
                if (c > 1):
                    c = 1
                x = colorScheme(c)
                x = (x[0]*SAVE_MAX, x[1]*SAVE_MAX, x[2]*SAVE_MAX)
                f.write("%d %d %d\n" %(x[0], x[1], x[2]))
    saveColor = staticmethod(saveColor)
    
    def loadToGreyscale(filename):
        f = open(filename, "r")
        f.readline()
        dimensions = map(int,f.readline().split(' '))
        maxValue = int(f.readline())
        print "Dimensions",dimensions

        data = []
        row = []
        c = 0
        band = 0;
        pixel = [];

        for line in f:
            tokens = map(float, line.split())
            for t in tokens:
                pixel.append(t)
                band += 1
                if (band == 3):
                    value = sum(pixel) / 3.0 / maxValue
                    pixel = []
                    band = 0

                    row.append(value)
                    
                    c += 1
                    if (c == dimensions[0]):
                        data.append(row)
                        c = 0
                        row = []
            
        return data
    loadToGreyscale = staticmethod(loadToGreyscale)

