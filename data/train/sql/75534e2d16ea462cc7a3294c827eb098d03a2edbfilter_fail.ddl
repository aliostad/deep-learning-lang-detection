HDF5 "filter_fail.h5" {
GROUP "/" {
   DATASET "dset_fail" {
      DATATYPE  H5T_STD_I32LE
      DATASPACE  SIMPLE { ( 10 ) / ( 10 ) }
      DATA {
      }
   }
}
}
HDF5-DIAG: Error detected in HDF5 (version (number)) thread (IDs):
  #000: (file name) line (number) in H5Dread(): can't read data
    major: Dataset
    minor: Read failed
  #001: (file name) line (number) in H5D_read(): can't read data
    major: Dataset
    minor: Read failed
  #002: (file name) line (number) in H5D_chunk_read(): unable to read raw data chunk
    major: Low-level I/O
    minor: Read failed
  #003: (file name) line (number) in H5D_chunk_lock(): data pipeline read failed
    major: Data filters
    minor: Filter operation failed
  #004: (file name) line (number) in H5Z_pipeline(): required filter 'filter_fail_test' is not registered
    major: Data filters
    minor: Read failed
h5dump error: unable to print data
H5tools-DIAG: Error detected in HDF5:tools (version (number)) thread (IDs):
  #000: (file name) line (number) in h5tools_dump_simple_dset(): H5Dread failed
    major: Failure in tools library
    minor: error in function
