var menuTop = document.getElementById( 'cbp-spmenu-s3' ),
				body = document.body;

			showTop.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuTop, 'cbp-spmenu-open' );
				disableOther( 'showTop','showTop1','showTopnew' );
			};
			
			showTop1.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuTop, 'cbp-spmenu-open' );
				disableOther( 'showTop','showTop1','showTopnew' );
			};
			
			showTopnew.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuTop, 'cbp-spmenu-open' );
				disableOther( 'showTop','showTop1','showTopnew' );
			};
			
			function disableOther( button ) {
				if( button !== 'showTop', 'showTop1', 'showTopnew' ) {
					classie.toggle( showTop, showTop1, showTopnew, 'disabled' );
				}
			}