#!/usr/bin/python
import PIL.Image
import lsb,sys
source = PIL.Image.open('quelle.png')
source.show()
r,g,b,a = source.split()
rb0 = lsb.getlayer(r,0)
gb0 = lsb.getlayer(g,0)
bb0 = lsb.getlayer(b,0)
ab0 = lsb.getlayer(a,0)

rb0.save('anstemp_r_0.png')
gb0.save('anstemp_g_0.png')
bb0.save('anstemp_b_0.png')
ab0.save('anstemp_a_0.png')

rb1 = lsb.getlayer(r,1)
gb1 = lsb.getlayer(g,1)
bb1 = lsb.getlayer(b,1)
ab1 = lsb.getlayer(a,1)

rb1.save('anstemp_r_1.png')
gb1.save('anstemp_g_1.png')
bb1.save('anstemp_b_1.png')
ab1.save('anstemp_a_1.png')
