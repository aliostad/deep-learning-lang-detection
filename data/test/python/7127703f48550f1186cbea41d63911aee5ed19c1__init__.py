"""color methods"""


def color(r, g, b):
	assert 256 > r > -1, "expected integer in range 0-255"
	assert 256 > g > -1, "expected integer in range 0-255"
	assert 256 > b > -1, "expected integer in range 0-255"
	return '#%02x%02x%02x' % (r, g, b)


def color_to_rgb(html_color):
	if len(html_color) == 7 and html_color[0] == '#':
		try:
			return (
					int(html_color[1:3], 16), 
					int(html_color[3:5], 16), 
					int(html_color[5:7], 16)
					)
		except:
			pass
	raise ValueError('invalid html color: %s' % color)

	
_B_SAVE = (0, 0x33, 0x66, 0xcc, 0xff)
_B_SAVE2 = (0x19, 0x33, 0x66, 0x7f)
def is_browser_save(color):
	r, g, b = color_to_rgb(color)
	return r in _B_SAVE and g in _B_SAVE and b in _B_SAVE


def make_browser_save(html_color):
	def make_save(ushort):
		if ushort <= _B_SAVE2[0]: return _B_SAVE[0]
		if ushort <= _B_SAVE2[1]: return _B_SAVE[1]
		if ushort <= _B_SAVE2[2]: return _B_SAVE[2]
		if ushort <= _B_SAVE2[3]: return _B_SAVE[3]
		return _B_SAVE[4]
	r, g, b = color_to_rgb(html_color)
	return color(make_save(r), make_save(g), make_save(b))


