-- Copyright (c) 2001-2014 Genome Research Ltd.
--
-- Authors: David Harper
--          Ed Zuiderwijk
--          Kate Taylor
--
-- This file is part of Arcturus.
--
-- Arcturus is free software: you can redistribute it and/or modify it under
-- the terms of the GNU General Public License as published by the Free Software
-- Foundation; either version 3 of the License, or (at your option) any later
-- version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
-- details.
--
-- You should have received a copy of the GNU General Public License along with
-- this program. If not, see <http://www.gnu.org/licenses/>.

-- find-free-read-details.sql
-- used to populate ORGANISM_HISTORY

-- for all projects in the database

create temporary table yesterday_reads_in_contigs as  
select READINFO.read_id, readname, cstart, cfinish, direction, asped, status
from CONTIG, READINFO, SEQ2READ, MAPPING 
where
		CONTIG.contig_id = MAPPING.contig_id and
	  MAPPING.seq_id = SEQ2READ.seq_id and 
		SEQ2READ.read_id = READINFO.read_id and
		CONTIG.contig_id in 
     (select distinct CA.contig_id from CONTIG as CA left join (C2CMAPPING,CONTIG as CB)
     on (CA.contig_id = C2CMAPPING.parent_id and C2CMAPPING.contig_id = CB.contig_id)
     where date(CA.created) < date(now())-1  and CA.nreads > 1 and CA.length >= 0 and (C2CMAPPING.parent_id is null  or date(CB.created) > date(now())-2));

create index read_id on yesterday_reads_in_contigs(read_id) using btree;

create temporary table yesterday_free_reads as  
select READINFO.read_id, readname, cstart, cfinish, direction, asped, status
from  READINFO, MAPPING, SEQ2READ
where 
  MAPPING.seq_id = SEQ2READ.seq_id  and
	SEQ2READ.read_id = READINFO.read_id and
	READINFO.read_id not in
     (select read_id from yesterday_reads_in_contigs);

select * from yesterday_free_reads order by asped, readname;
