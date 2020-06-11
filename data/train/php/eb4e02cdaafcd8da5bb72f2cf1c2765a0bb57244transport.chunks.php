<?php
$chunkArray = array();

/* default agenda chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsEvent');
$chunk->set('description', 'Default Google Calendar agenda event template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.event.chunk.tpl'));

$chunkArray[] = $chunk;

/* default agenda wrapper chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsWrapper');
$chunk->set('description', 'Default Google Calendar agenda events wrapper template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.wrap.chunk.tpl'));

$chunkArray[] = $chunk;

/* default week wrapper chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsWeekWrapper');
$chunk->set('description', 'Default Google Calendar week wrapper template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.week.wrap.chunk.tpl'));

$chunkArray[] = $chunk;

/* default week event chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsWeekEvent');
$chunk->set('description', 'Default Google Calendar week event template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.week.event.chunk.tpl'));

$chunkArray[] = $chunk;

/* default week event chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcalEventsWeekAlldayEvent');
$chunk->set('description', 'Default Google Calendar week allday event template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.week.eventallday.chunk.tpl'));

$chunkArray[] = $chunk;

/* default week day chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsWeekDay');
$chunk->set('description', 'Default Google Calendar week day template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.week.day.chunk.tpl'));

$chunkArray[] = $chunk;

/* default week day header chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsWeekDayHeader');
$chunk->set('description', 'Default Google Calendar week day header template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.week.dayheader.chunk.tpl'));

$chunkArray[] = $chunk;

/* default week timscale chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsWeekTimescale');
$chunk->set('description', 'Default Google Calendar week timescale template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.week.timescale.chunk.tpl'));

$chunkArray[] = $chunk;

/* default week timscale blank chunk */
$chunk= $modx->newObject('modChunk');
$chunk->set('id',0);
$chunk->set('name', 'gcaleventsWeekTimescaleBlank');
$chunk->set('description', 'Default Google Calendar week blank timescale template.');
$chunk->set('snippet',file_get_contents($sources['source_core'].'/chunks/gcalevents.week.timescaleblank.chunk.tpl'));

$chunkArray[] = $chunk;

return $chunkArray;