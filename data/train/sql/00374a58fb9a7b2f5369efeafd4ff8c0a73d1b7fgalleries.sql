--alter table imagetable alter column uploadtime type timestamp with time zone;
insert into galleryTable values ('Nature', Null, 'readGalleryCapability', 'uploadImageCapability', 'administerGalleryCapability');
insert into galleryTable values ('Donkey shit', Null, 'forbidden', 'forbidden', 'administerGalleryCapability');
insert into galleryTable values ('Dragonflies', 'Nature', 'readGalleryCapability', 'uploadImageCapability', 'administerGalleryCapability');
insert into galleryTable values ('Black Darter', 'Dragonflies', 'readGalleryCapability', 'uploadImageCapability', 'administerGalleryCapability');
insert into galleryTable values ('Common Darter', 'Dragonflies', 'readGalleryCapability', 'uploadImageCapability', 'administerGalleryCapability');
insert into galleryTable values ('Ruddy Darter', 'Dragonflies', 'readGalleryCapability', 'uploadImageCapability', 'administerGalleryCapability');
insert into galleryTable values ('Thailand dragonflies', 'Dragonflies', 'readGalleryCapability', 'uploadImageCapability', 'administerGalleryCapability');
insert into galleryTable values ('Rubbish', 'Thailand dragonflies', 'readGalleryCapability', 'forbidden', 'administerGalleryCapability');


