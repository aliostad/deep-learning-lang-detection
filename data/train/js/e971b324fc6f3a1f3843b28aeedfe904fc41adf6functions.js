var canShow = false;

function act_on_nr(act,nr) {
	var id1 = 'zabieg'+nr;
	var id2 = 'hide'+nr;
	var id3 = 'show'+nr;
	if (act == 'show') {
		Effect.BlindDown(id1, { duration: .5 });
		$(id2).show();
		$(id3).hide();
	} else {
		Effect.BlindUp(id1, { duration: .5 });
		$(id2).hide();
		$(id3).show();
		canShow = true;
	}			
}

function act_on_all(act) {

	if (act == 'show') {
		if (canShow) {
			canShow=false;
			for (i=1;i!=14;i++) {
				act_on_nr('show',i);
			}
		}
	} else {
		canShow=true;
		for (i=1;i!=14;i++) {
			act_on_nr('hide',i);
		}
	}			
}
