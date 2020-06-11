prompt mostra informações do disk group a nivel de ASM clustered gv$
prompt verificar qual DG tem um service time alto, pode ser necessário adicionar mais discos ou discos com menor latencia
SELECT name, 
	ROUND(total_mb / 1024) total_gb, active_disks,
	reads / 1000 reads1k, writes / 1000 writes1k,
	ROUND(read_time) read_time, ROUND(write_time) write_time,
	ROUND(read_time * 1000 / reads, 2) avg_read_ms
FROM v$asm_diskgroup_stat dg
	JOIN (SELECT group_number, 
				COUNT(DISTINCT disk_number) active_disks,
				SUM(reads) reads, 
				SUM(writes) writes,
				SUM(read_time) read_time, 
				SUM(write_time) write_time
		 FROM gv$asm_disk_stat
		 WHERE mount_status = 'CACHED'
		 GROUP BY group_number) ds
		ON (ds.group_number = dg.group_number)
ORDER BY dg.group_number;
