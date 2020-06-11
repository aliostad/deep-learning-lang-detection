import studio

program f1 [# $ check ck rescheck hash_preprocessor list_preprocessor
		f1 var_preprocessor
		rescheck_list_tail rescheck_cont var_preprocessor_cont
		]

[[ck *x] [not is_var *x] [eq *x #] /]
[[ck *x] [is_var *x] / fail]
[[ck [*head : *tail]] [not is_var *head] [eq *head #]]
[[ck [*head : *tail]] [ck *tail]]

[[check * *x * *] [is_var *x] / fail]
[[check *var *h *var *] [not is_var *h] [eq *h #]]
[[check *var [*h : *tail] [*var : *tail] *] [not is_var *h] [eq *h #]]
[[check *var [*head : *tail] [*head : *tail2] *ret] [check *var *tail *tail2 *ret]]
[[check *var [*head : *tail] [*var : *tail] *head2] [ck *head] [check *var *head *head2 *]]
[[check *var [*head : *tail] [*head2 : *tail] *res] [check *var *head *head2 *res]]

[[hash_preprocessor *x *y]
	[check *sonda *x *instructions *instruction]
;	[show "	preprocessing => " [*instruction : *instructions]]
	/ [hash_preprocessor [*instruction : *instructions] *y]]
[[hash_preprocessor *x *x]]

[[list_preprocessor [] []]]
[[list_preprocessor [*h1 : *t1] *res]
	[hash_preprocessor [*h1] *h2]
	[list_preprocessor *t1 *t2]
	[APPEND *h2 *t2 *res]]

[[rescheck_cont *t *t] [is_var *t] /]
[[rescheck_cont *t *t2] [rescheck *t *t2]]
[[rescheck_list_tail *t1 *t2] [rescheck_cont *t1 *tx] [list_preprocessor *tx *t2]]
[[rescheck [*res : *tail] [res : *tail2]] [is_atom *res] [eq *res res] / [rescheck_list_tail *tail *tail2]]
[[rescheck [*head : *tail] [*head : *t2]] [is_var *head] /
	[rescheck_cont *tail *t2]/]
[[rescheck [*head : *tail] [*h2 : *t2]]
	[rescheck *head *h2] /
	[rescheck_cont *tail *t2] /]
[[rescheck *x *x]/]


[[var_preprocessor_cont *t *t] [is_var *t] /]
[[var_preprocessor_cont *t *t2] [var_preprocessor *t *t2]]
[[var_preprocessor [*u *array : *tail] [*call : *t2]] [is_atom *u] [eq *u $]
	[not is_var *array] [eq *array [*a : *i]]
	/ [APPEND [*a : *i] # *call]
	/ [var_preprocessor_cont *tail *t2]]
[[var_preprocessor [*u *var : *tail] [[*var : #] : *t2]] [is_atom *u] [eq *u $]
	/ [var_preprocessor_cont *tail *t2]]
[[var_preprocessor [*h : *t] [*h : *t2]] [is_var *h] / [var_preprocessor_cont *t *t2] /]
[[var_preprocessor [*h : *t] [*h2 : *t2]]
	/ [var_preprocessor *h *h2]
	/ [var_preprocessor_cont *t *t2]]
[[var_preprocessor *x *x]]

[[f1 [*head : *tail]]
	[var_preprocessor *tail *t2]
	[rescheck_list_tail *t2 *t3]/
	[addcl [*head : *t3]]
]
[[f1 *x *y]
	[var_preprocessor *x *z]
	[rescheck_list_tail *z *y]/
;	[show "	preprocessed => " *y]
]

protect [check ck rescheck hash_preprocessor list_preprocessor
	f1 var_preprocessor rescheck_list_tail
	rescheck_cont var_preprocessor_cont
	]
private [check ck rescheck hash_preprocessor list_preprocessor var_preprocessor
	rescheck_list_tail rescheck_cont var_preprocessor_cont]

end .
