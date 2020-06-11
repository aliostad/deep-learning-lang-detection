program scala_reader
	[read_scala rs]


[[read_scala *file *channel]
	[create_atom *atom]
	[file_reader *atom *file]
	/
	[*atom "note" *note]
	/
	[rs *atom *note *channel]]

[[rs *atom "note" *channel]
	[*atom *key]
	[*atom "=" *]
	[*atom *frequency]
	[mult *frequency 1.28 *freq]
	[trunc *freq *ifreq]
	[pp [NRPN *channel 4 *key *ifreq]] [nl]
	[NRPN *channel 4 *key *ifreq]
	[*atom "note" *next]
	/
	[rs *atom *next *channel]]

[[rs *atom *note *channel] [*atom "note" *next] / [rs *atom *next *channel]]
[[rs *atom :*] [*atom]]


end.