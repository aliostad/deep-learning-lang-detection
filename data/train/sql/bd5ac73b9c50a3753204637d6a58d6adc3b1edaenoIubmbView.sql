-- IUBMB view is not used anymore, let's clean up our data.

update cofactors
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update cofactors
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

update comments
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update comments
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

update links
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update links
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

update names
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update names
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

update publications
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update publications
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

update reactions
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update reactions
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

update reactions_map
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update reactions_map
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

update xrefs
set web_view = 'INTENZ' where web_view = 'IUBMB_INTENZ';
update xrefs
set web_view = 'SIB' where web_view = 'IUBMB_SIB';

delete from cv_view where code like 'IUBMB%';
