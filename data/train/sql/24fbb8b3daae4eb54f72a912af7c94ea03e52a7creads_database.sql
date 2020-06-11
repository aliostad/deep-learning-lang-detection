DROP TABLE IF EXISTS SequenceReads;
DROP TABLE IF EXISTS Alignments;

CREATE TABLE SequenceReads(
	read_id						VARCHAR(40)	NOT NULL,
	read_seq					TEXT,
	read_length					INT,
	PRIMARY KEY(read_id)
);

CREATE TABLE Alignments(
	alignment_id					INT			AUTO_INCREMENT		NOT NULL,
	read1_id					VARCHAR(40),
	read2_id					VARCHAR(40),
	sequence1					TEXT,
	sequence2					TEXT,
	alignment_length				INT,
	identity					INT,
	similarity					INT,
	gaps						INT,
	PRIMARY KEY(alignment_id),
	FOREIGN KEY(read1_id)
		REFERENCES SequenceReads(read_id),
	FOREIGN KEY(read2_id)
		REFERENCES SequenceReads(read_id)
);
