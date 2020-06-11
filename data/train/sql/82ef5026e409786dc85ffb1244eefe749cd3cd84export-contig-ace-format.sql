--	Retrieve a contig's info stored in a ChadoDB instnace in ACE file format
--
--	Copyright (c) 2012 Diego I. Dayan, SFSU
--
--	Permission is hereby granted, free of charge, to any person obtaining a copy
--	of this software and associated documentation files (the "Software"), to deal
--	in the Software without restriction, including without limitation the rights
--	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--	copies of the Software, and to permit persons to whom the Software is
--	furnished to do so, subject to the following conditions:
--	
--	The above copyright notice and this permission notice shall be included in
--	all copies or substantial portions of the Software.
--	
--	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--	THE SOFTWARE.

-- Auxiliary table to build the N lines of 50 nucleotides each
WITH RECURSIVE numbers(n) AS (
    VALUES (1)
    UNION ALL
    SELECT n+1 FROM numbers WHERE n < 1000

), contig_identifier AS (
   -- change this with your feature_id (contig_id) and the cvterm of your database (e.g., 'contig')
   -- valid contig_ids are (1029, 34, ...)
   SELECT 1029 as id, cast('contig' as text) as cvterm
   
), contig AS (
   SELECT contig.feature_id as contig_id,
	  contig.uniquename as contig_name,
	  -- IMPORTANT: change this to contig.residues when the content is pre-computed
	  --		 we want one row per contig, not many
          substring(read.residues from fl.fmin+1 for fl.fmax-fl.fmin+1) as contig_sequence,
	  -- IMPORTANT: these below doesn't make sense when we get 1 row per contig
	  fl.fmin, fl.fmax,
	  read.uniquename as read_name
   FROM feature contig
   JOIN featureloc fl ON (contig.feature_id = fl.feature_id)
   JOIN feature read ON (fl.srcfeature_id = read.feature_id)
   WHERE contig.is_analysis = 'f'
     AND contig.type_id IN (SELECT cvterm_id FROM cvterm WHERE name IN (SELECT cvterm FROM contig_identifier))
     AND contig.feature_id IN (SELECT id FROM contig_identifier)
   ORDER BY read.uniquename
   
), contig_detail AS (
   SELECT substring(contig_sequence from cast((ROW_NUMBER() OVER (ORDER BY contig_id ASC) - 1) * 50 + 1 as integer) for 50) as line
   FROM contig, numbers -- use numbers temporal table to multiply the same row n times
   WHERE numbers.n <= LENGTH(cast(contig_sequence as text)) / 50 + 1 -- int division, up to n pieces of 50 nucleotides

), contig_section AS (
   SELECT line FROM contig_summary
   UNION ALL SELECT line FROM contig_detail WHERE line != ''

), read_temp AS (
   SELECT read.feature_id as read_id,
	  read.uniquename as read_name,
	  cast(read.residues as text) as read_sequence,
	  fl.fmin,
	  fl.fmax,
	  (ROW_NUMBER() OVER (ORDER BY read.feature_id) - 1) as read_index
   FROM feature read
   JOIN featureloc fl ON (fl.srcfeature_id = read.feature_id)
   WHERE fl.feature_id IN (SELECT id FROM contig_identifier)
   ORDER BY read.uniquename

), read AS (
   SELECT *,
	sum((LENGTH(read_sequence) / 50 + 1) * read_index) OVER (ORDER BY read_id) as rows_so_far
   FROM read_temp

), reads_summary AS (
   SELECT COUNT(1) as count FROM read

), read_sequence AS (
   SELECT read_id,
      cast('RD' as text) as section,
      ROW_NUMBER() OVER (ORDER BY read_id) - rows_so_far as line_number,
      substring(read_sequence from cast((ROW_NUMBER() OVER (ORDER BY read_id ASC) - 1 - rows_so_far) * 50 + 1 as integer) for 50) as line  
   FROM read, numbers -- use numbers temporal table to multiplicate the same row n times
   WHERE numbers.n <= LENGTH(cast(read_sequence as text)) / 50 + 1 -- int division, up to n pieces of 50 nucleotides
   ORDER BY read_id

), af_section AS ( 
   -- AF section (listing of reads)
   SELECT read_id as read_id,
      cast('AF' as text) as section,
      -1 as line_number,
      cast('AF ' as text) -- read
      || cast(read_name as text) -- uniquename
      || cast(' U ' as text)
      || cast((-1) * fmin + 1 as text) as line -- offset, it's 1-based (not interbase)
   FROM read

), read_section AS (
   -- contains the entire dump of reads
   -- also contains the read_id and the line_number, that is used
   -- later to output in order
   
   -- read summary (uniquename, length, etc)
   SELECT DISTINCT read_id,
      cast('RD' as text) as section,
      0 as line_number,
      cast('RD ' as text) -- read
      || cast(read_name as text) -- uniquename
      || cast(' ' as text) || cast(LENGTH(read_sequence) as text) -- length
      || cast(' ' as text) || cast(0 as text) -- unknown
      || cast(' ' as text) || cast(0 as text) -- unknwon
      as line
   FROM read

   -- read content (residues, in rows of 50 chars)
   UNION ALL SELECT read_id, section, line_number, line FROM read_sequence

   -- read alignment info
   UNION ALL (SELECT DISTINCT read_id,
     cast('RD' as text) as section,
     9999999999 as line_number, -- big number, so it always is at the end
     cast('\nQA ' as text)
     || cast(fmin + 1 as text) -- init position
     || cast(' ' as text) || cast(fmax + 1 as text) -- length from that position
     || cast(' ' as text) || cast(fmin + 1 as text)
     || cast(' ' as text) || cast(fmax + 1 as text)
     || cast('\n' as text) as line
   FROM "read" ORDER BY read_id)

), contig_summary AS (
   -- contains a list with the main info about contigs in this file (it's only 1 for now)
   SELECT DISTINCT cast('CO ' as text) -- COntig
    || cast(contig_name as text) -- uniquename
    || cast(' ' as text)
    || cast(length(contig_sequence) as text) -- length
    || cast(' ' as text)
    || cast(reads_summary.count as text) -- number of reads
    || cast(' ' as text)
    || cast(0 as text) -- number of base segments NOT IMPLEMENTED
    || cast(' U' as text) as line
   FROM contig, reads_summary

), ace_header AS (
   -- SECTION 1, HEADER. Compound by:
   -- nbr of contigs, it is 1 because we are generating output for a single contig
   -- nbr of reads in this file
   SELECT DISTINCT cast('AS 1 ' as text) || (SELECT count FROM reads_summary) as line
   FROM read

), ace_file AS (
   SELECT line FROM ace_header
   UNION ALL (SELECT '')
   UNION ALL (SELECT line FROM contig_section)
   UNION ALL (SELECT '')
   UNION ALL (SELECT line FROM af_section ORDER BY read_id)
   UNION ALL (SELECT '')
   UNION ALL (SELECT line FROM read_section WHERE section = 'RD' ORDER BY read_id, line_number)

) SELECT line FROM ace_file;