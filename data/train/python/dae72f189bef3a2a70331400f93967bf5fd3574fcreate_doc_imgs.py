import os
from transmogrify import Transmogrify

square_img = os.path.abspath(os.path.join(os.path.dirname(__file__), 'testdata', 'square_img.jpg'))
vert_img = os.path.abspath(os.path.join(os.path.dirname(__file__), 'testdata', 'vert_img.jpg'))
horiz_img = os.path.abspath(os.path.join(os.path.dirname(__file__), 'testdata', 'horiz_img.jpg'))


####
#### AutoCrop
####
Transmogrify(square_img, [('a', '100x100'),]).save()
Transmogrify(vert_img, [('a', '100x100'),]).save()
Transmogrify(horiz_img, [('a', '100x100'),]).save()


####
#### Thumbnail
####
Transmogrify(square_img, [('t', '200'),]).save()
Transmogrify(vert_img, [('t', '200'),]).save()
Transmogrify(horiz_img, [('t', '200'),]).save()

Transmogrify(square_img, [('t', 'x200'),]).save()
Transmogrify(vert_img, [('t', 'x200'),]).save()
Transmogrify(horiz_img, [('t', 'x200'),]).save()

Transmogrify(square_img, [('t', '200x200'),]).save()
Transmogrify(vert_img, [('t', '200x200'),]).save()
Transmogrify(horiz_img, [('t', '200x200'),]).save()

####
#### Resize
####
Transmogrify(square_img, [('r', '500'),]).save()
Transmogrify(vert_img, [('r', '500'),]).save()
Transmogrify(horiz_img, [('r', '500'),]).save()

Transmogrify(square_img, [('r', 'x500'),]).save()
Transmogrify(vert_img, [('r', 'x500'),]).save()
Transmogrify(horiz_img, [('r', 'x500'),]).save()

Transmogrify(square_img, [('r', '500x500'),]).save()
Transmogrify(vert_img, [('r', '500x500'),]).save()
Transmogrify(horiz_img, [('r', '500x500'),]).save()

####
#### Letterbox
####
Transmogrify(square_img, [('l', '500x500-f00'),]).save()
Transmogrify(vert_img, [('l', '500x500-f00'),]).save()
Transmogrify(horiz_img, [('l', '500x500-f00'),]).save()

Transmogrify(square_img, [('l', '500x500-fffee1'),]).save()
Transmogrify(vert_img, [('l', '500x500-fffee1'),]).save()
Transmogrify(horiz_img, [('l', '500x500-fffee1'),]).save()

####
#### ForceFit
####
Transmogrify(square_img, [('s', '300x300'),]).save()
Transmogrify(vert_img, [('s', '300x300'),]).save()
Transmogrify(horiz_img, [('s', '300x300'),]).save()

####
#### Crop
####
Transmogrify(square_img, [('c', '100x100'),]).save()
Transmogrify(vert_img, [('c', '100x100'),]).save()
Transmogrify(horiz_img, [('c', '100x100'),]).save()

####
#### Filter
####
Transmogrify(square_img, [('r', '300x300'), ('f', 'blur')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'contour')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'detail')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'edge_enhance')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'edge_enhance_more')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'emboss')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'find_edges')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'smooth')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'smooth_more')]).save()
Transmogrify(square_img, [('r', '300x300'), ('f', 'sharpen')]).save()

####
#### Border
####
Transmogrify(square_img, [('r', '300x300'), ('b', '3-fffee1')]).save()
