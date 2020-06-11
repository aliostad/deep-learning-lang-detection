import studio
import f1

program randezvous #auto

[[gospoda] [gospoda ada]]
[[gospoda *task]
	[var [pieczywo 0] [mieso 0]]
	[task *task [gospoda dostarczmieso dostarczpieczywo status exit]
		[FOREVER
			[show "ready...."]
			[pieczywo : *p] [mieso : *m]
			[SELECT
				[[*task select status [*p *m] [show "pieczywo = " *p] [show "mieso = " *m]]]
				[[*task select exit []] [*task] [timeout]]
				[[*task select dostarczpieczywo [*pieczywo] [pieczywo *pieczywo] [show "Dostalem pieczywo [" *pieczywo "]"]]]
				[[*task select dostarczmieso [*mieso] [mieso *mieso] [show "Dostalem mieso [" *mieso "]"]]]
				[[greater *p 0] [greater *m 0] [*task select gospoda [*pk]
					[rnd *time 1000 5000] [write "gotuje => " [*time]] [wait *time] [write " mieso\n"]
					[sum *m *p *pk]
					[wait 4000]
					[pieczywo 0] [mieso 0]
				]]
				[[*task wait]]
			]
			[show "..... loop"]
		]
	]
]

[[train *task] [task *task[exit status]]]
[[train] [train ada]]

[[a]  [crack [ada accept exit [1 2 3] [show "processing...."] [wait 2000] [show "....processed"]] [show "accepted"]]]
[[s]  [crack [ada select exit [1 2 3] [show "selecting...."] [wait 2000] [show "....selected"]] [show "accepted"]]]
[[ss] [crack [ada select status [5 6 7] [show "status selecting....."] [wait 2000] [show "....status selected"]] [show "accepted"]]]
[[b]  [crack [ada enter exit 1 *x 3] [show *x]]]
[[bs] [crack [ada enter status : *x] [show *x]]]

end := [[set_colors 16776960 0] [auto_atoms] [command]] .


auto := [
	[VARIABLE kanapki] [kanapki 0]
	[VARIABLE pieczywo] [pieczywo 0]
	[VARIABLE mieso] [mieso 0]
	]

[[gotujmieso *m]
	[rnd *time 100 5000]
	[mieso : *m]
	[write "gotuje => "] [wait *time] [show "mieso " [*time *m]]
	[mieso 0]
	]

[[robkanapki *k]
	[pieczywo : *p]
	[mieso : *mieso]
	[less 0 *mieso] [less 0 *p]
	[gotujmieso *m]
	[add *m *p *k]
	[pieczywo 0]
	[kanapki *k]
	]
[[robkanapki] [write "		Nie moge zrobic kanapek.\n"]]

[[status]
	[mieso : *m] [pieczywo : *p] [kanapki : *k]
	[show "mieso " [*m] " pieczywo " [*p] " kanapki " [*k]]
	]

[[akceptuj_pieczywo *task 0]
	[accept *task dostarczpieczywo [*pieczywo]]
	[pieczywo *pieczywo]
	[show "Dostalem pieczywo => " *pieczywo]
	]
[[akceptuj_mieso *task 0]
	[accept *task dostarczmieso [*mieso]]
	[mieso *mieso]
	[show "Dostalem mieso => " *mieso]
	]
[[akceptuj_klienta *task *p *m]
	[less 0 *p] [less 0 *m]
	[accept *task gospoda [*pk]
		[robkanapki *pk]
		[show "	Zrobilem kanapki => " *pk]
		]
	[wait 4000] [kanapki 0]
	]

[[gospoda *task]
	[task *task [dostarczpieczywo dostarczmieso gospoda status exit]
		[FOREVER
			[pieczywo : *p] [mieso : *m]
			[select *task
				[[akceptuj_pieczywo *task *p]]
				[[akceptuj_mieso *task *m]]
				[[akceptuj_klienta *task *p *m]]
				[[accept *task exit [] [show "EXITING...."]] [show "applying timeout"] [timeout [show "timeout"]]]
			]
			[show "		.... done one loop"]
			[show "		.... done another loop"]
		]
	]
]

auto := [[gospoda ada]]

end := [[set_colors 16776960 0] [auto_atoms] [command]] .
