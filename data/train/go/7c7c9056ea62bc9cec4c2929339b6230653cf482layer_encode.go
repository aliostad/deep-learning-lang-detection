package xcf

import (
	"image"

	"github.com/MJKWoolnough/limage"
)

func (e *encoder) WriteLayers(layers limage.Image, offsetX, offsetY int32, groups []uint32, pw *pointerWriter) {
	for n, layer := range layers {
		nGroups := append(groups, uint32(n))
		e.WriteLayer(layer, offsetX+int32(layer.LayerBounds.Min.X), offsetY+int32(layer.LayerBounds.Min.Y), nGroups, pw)
	}
}

func (e *encoder) WriteLayer(im limage.Layer, offsetX, offsetY int32, groups []uint32, pw *pointerWriter) {
	pw.WritePointer(uint32(e.pos))

	var (
		mask  *image.Gray
		img   image.Image
		text  limage.TextData
		group limage.Image
	)
	if mim, ok := im.Image.(limage.MaskedImage); ok {
		mask = mim.Mask
		img = mim.Image
	} else if mim, ok := im.Image.(*limage.MaskedImage); ok {
		mask = mim.Mask
		img = mim.Image
	} else {
		img = im.Image
	}

	switch i := im.Image.(type) {
	case limage.Text:
		text = i.TextData
	case *limage.Text:
		text = i.TextData
	case limage.Image:
		group = i
	case *limage.Image:
		group = *i
	}

	b := im.Bounds()
	dx, dy := uint32(b.Dx()), uint32(b.Dy())
	e.WriteUint32(dx)
	e.WriteUint32(dy)
	e.WriteUint32(uint32(e.colourType)<<1 | 1)
	e.WriteString(im.Name)

	e.WriteUint32(propOpacity)
	e.WriteUint32(4)
	e.WriteUint32(255 - uint32(im.Transparency))

	e.WriteUint32(propVisible)
	e.WriteUint32(4)
	if im.Invisible {
		e.WriteUint32(0)
	} else {
		e.WriteUint32(1)
	}

	e.WriteUint32(propOffsets)
	e.WriteUint32(8)
	e.WriteInt32(offsetX)
	e.WriteInt32(offsetY)

	if len(groups) > 1 {
		e.WriteUint32(propItemPath)
		e.WriteUint32(4 * uint32(len(groups)))
		for _, g := range groups {
			e.WriteUint32(g)
		}
	}

	if len(text) > 0 {
		e.WriteText(text, dx, dy)
	}

	if group != nil {
		e.WriteUint32(propGroupItem)
		e.WriteUint32(0)
	}

	e.WriteUint32(propMode)
	e.WriteUint32(4)
	e.WriteUint32(uint32(im.Mode))

	e.WriteUint32(0) // end of properties
	e.WriteUint32(0)

	// write layer

	ptrs := e.ReservePointers(2)
	ptrs.WritePointer(uint32(e.pos))

	e.WriteImage(img, e.colourFunc, e.colourChannels)
	if mask != nil {
		ptrs.WritePointer(uint32(e.pos))
		e.WriteChannel(mask)
	} else {
		ptrs.WritePointer(0)
	}
	if group != nil {
		e.WriteLayers(group, offsetX, offsetY, groups, pw)
	}
}
