DELIMITER //

DROP PROCEDURE IF EXISTS read2db//
CREATE PROCEDURE read2db(
IN id VARCHAR(40),
IN seq TEXT,
IN leng INT
)
BEGIN
INSERT INTO SequenceReads(
read_id,
read_seq,
read_length
)
VALUES(
id,
seq,
leng
);
END;
//

DROP PROCEDURE IF EXISTS alignment2db//
CREATE PROCEDURE alignment2db(
IN id1 VARCHAR(40),
IN id2 VARCHAR(40),
IN seq1 TEXT,
IN seq2 TEXT,
IN leng INT,
IN ident INT,
IN sim INT,
IN gap INT
)
BEGIN
INSERT INTO Alignments(
read1_id,
read2_id,
sequence1,
sequence2,
alignment_length,
identity,
similarity,
gaps
)
VALUES(
id1,
id2,
seq1,
seq2,
leng,
ident,
sim,
gap
);
END;
//

DELIMITER ;
