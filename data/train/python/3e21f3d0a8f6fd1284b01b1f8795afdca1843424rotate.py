# -(0)
from PIL import Image
# -(/0)

# -(1)
img = Image.open("flowers.jpg")
# -(/1)

# -(2)
img2 = img.rotate(45)
# -(/2)
img2.save("img2.jpg")

# -(3)
img3 = img.rotate(90)
# -(/3)
img3.save("img3.jpg")

# -(4)
img4 = img.rotate(-45)
# -(/4)
img4.save("img4.jpg")

# -(5)
img5 = img.rotate(45, expand=True)
# -(/5)
img5.save("img5.jpg")

# -(6)
img6 = img.rotate(45, resample=Image.NEAREST)
# -(/6)
img6.save("img6.jpg")

# -(7)
img7 = img.rotate(45, resample=Image.BILINEAR)
# -(/7)
img7.save("img7.jpg")

# -(8)
img8 = img.rotate(45, resample=Image.BICUBIC)
# -(/8)
img8.save("img8.jpg")
