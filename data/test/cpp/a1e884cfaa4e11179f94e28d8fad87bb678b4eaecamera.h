#include <stdio.h>

void 
parse_ciff(FILE * const ifp,
           int    const offset,
           int    const length);

void
parse_external_jpeg(const char * const ifname);

void
parse_tiff(FILE * const ifp, int base);

void
parse_minolta(FILE * const ifp);

void
parse_rollei(FILE * const ifp);

void
parse_mos(FILE * const ifp,
          int    const offset);

void
adobe_dng_load_raw_lj(void);

void
adobe_dng_load_raw_nc(void);

int
nikon_is_compressed(void);

void
nikon_compressed_load_raw(void);

void
nikon_e950_load_raw(void);

void
nikon_e950_coeff(void);

int
nikon_e990(void);

int
nikon_e2100(void);

void
nikon_e2100_load_raw(void);

int
minolta_z2(void);

void
fuji_s2_load_raw(void);

void
fuji_s3_load_raw(void);

void
fuji_s5000_load_raw(void);

void
unpacked_load_raw(void);

void
fuji_s7000_load_raw(void);

void
fuji_f700_load_raw(void);

void
packed_12_load_raw(void);

void
eight_bit_load_raw(void);

void
phase_one_load_raw(void);

void
ixpress_load_raw(void);

void
leaf_load_raw(void);

void
olympus_e300_load_raw(void);

void
olympus_cseries_load_raw(void);

void
sony_load_raw(void);

void
kodak_easy_load_raw(void);

void
kodak_compressed_load_raw(void);

void
kodak_yuv_load_raw(void);

void
kodak_dc20_coeff (float const juice);

void
kodak_radc_load_raw(void);

void
kodak_jpeg_load_raw(void);

void
kodak_dc120_load_raw(void);

void
rollei_load_raw(void);

void
casio_qv5700_load_raw(void);

void
nucore_load_raw(void);

void
nikon_load_raw(void);

int
pentax_optio33(void);

