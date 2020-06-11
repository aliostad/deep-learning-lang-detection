var menuLeft = document.getElementById( 'cbp-spmenu-s1' ),
				menuRight = document.getElementById( 'cbp-spmenu-s2' ),
				menuRight1 = document.getElementById( 'cbp-spmenu-s5' ),
                                menuTop = document.getElementById( 'cbp-spmenu-s3' ),
				menuBottom = document.getElementById( 'cbp-spmenu-s4' ),
				showLeft = document.getElementById( 'showLeft' ),
				showRight = document.getElementById( 'showRight' ),
                                showRight1 = document.getElementById( 'showRight1' ),
				showTop = document.getElementById( 'showTop' ),
				showBottom = document.getElementById( 'showBottom' ),
				showLeftPush = document.getElementById( 'showLeftPush' ),
                                showTopPush = document.getElementById( 'showTopPush' ),
				showRightPush = document.getElementById( 'showRightPush' ),
				body = document.body;

			
			showLeftPush.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( body, 'cbp-spmenu-push-toright' );
				classie.toggle( menuLeft, 'cbp-spmenu-open' );
				disableOther( 'showLeftPush' );
			};
                        showTopPush.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( body, 'cbp-spmenu-push-todown' );
				classie.toggle( menuTop, 'cbp-spmenu-open' );
				disableOther( 'showTopPush' );
			};
                        showRight.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuRight, 'cbp-spmenu-open' );
				disableOther( 'showRight' );
			};
                        showRight1.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuRight1, 'cbp-spmenu-open' );
				disableOther( 'showRight1' );
			};

			function disableOther( button ) {
				if( button !== 'showLeft' ) {
					classie.toggle( showLeft, 'disabled' );
				}
				if( button !== 'showRight' ) {
					classie.toggle( showRight, 'disabled' );
				}
                                if( button !== 'showRight1' ) {
					classie.toggle( showRight1, 'disabled' );
				}
				if( button !== 'showTop' ) {
					classie.toggle( showTop, 'disabled' );
				}
				if( button !== 'showBottom' ) {
					classie.toggle( showBottom, 'disabled' );
				}
				if( button !== 'showLeftPush' ) {
					classie.toggle( showLeftPush, 'disabled' );
				}
                                if( button !== 'showTopPush' ) {
					classie.toggle( showTOpPush, 'disabled' );
				}
				if( button !== 'showRightPush' ) {
					classie.toggle( showRightPush, 'disabled' );
				}
			}