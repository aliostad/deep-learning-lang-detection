create or replace 
PACKAGE "LOAD_FNA_FILE_PACKAGE" as 

  TYPE split_library_run_id_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.SPLIT_LIBRARY_RUN_ID%TYPE INDEX BY BINARY_INTEGER;
  TYPE seq_run_id_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.SEQ_RUN_ID%TYPE INDEX BY BINARY_INTEGER;
  TYPE sequence_name_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.SEQUENCE_NAME%TYPE INDEX BY BINARY_INTEGER;
  TYPE sample_name_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.SAMPLE_NAME%TYPE INDEX BY BINARY_INTEGER;
  TYPE read_id_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.READ_ID%TYPE INDEX BY BINARY_INTEGER;
  TYPE orig_barcode_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.ORIG_BARCODE_SEQ%TYPE INDEX BY BINARY_INTEGER;
  TYPE new_barcode_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.NEW_BARCODE_SEQ%TYPE INDEX BY BINARY_INTEGER;
  TYPE barcode_diff_tab IS TABLE OF SPLIT_LIBRARY_READ_MAP.BARCODE_DIFF%TYPE INDEX BY BINARY_INTEGER;
  TYPE sequence_length_tab IS TABLE OF SSU_SEQUENCE.SEQUENCE_LENGTH%TYPE INDEX BY BINARY_INTEGER;
  TYPE md5_checksum_tab IS TABLE OF SSU_SEQUENCE.MD5_CHECKSUM%TYPE INDEX BY BINARY_INTEGER;
  TYPE sequence_string_tab IS TABLE OF SSU_SEQUENCE.SEQUENCE_STRING%TYPE INDEX BY BINARY_INTEGER;
  

  procedure array_insert 
  (
    split_library_run_ids in split_library_run_id_tab,
    seq_run_ids in seq_run_id_tab,
    sequence_names in sequence_name_tab,
    sample_names in sample_name_tab,
    read_ids in read_id_tab,
    orig_barcodes in orig_barcode_tab,
    new_barcodes in new_barcode_tab,
    barcode_diffs in barcode_diff_tab,
    sequence_lengths in sequence_length_tab,
    md5_checksums in md5_checksum_tab,
    sequence_strings in sequence_string_tab
  );

end load_fna_file_package;