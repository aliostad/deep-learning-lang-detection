/*
  Copyright (c) 2003-2011 Gordon Gremme <gremme@zbh.uni-hamburg.de>
  Copyright (c) 2003-2008 Center for Bioinformatics, University of Hamburg

  Permission to use, copy, modify, and distribute this software for any
  purpose with or without fee is hereby granted, provided that the above
  copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

#ifndef GENOMETOOLS_H
#define GENOMETOOLS_H

/* The GenomeTools ``all-in-one'' header.
   Include only this header if you program against the libgenometools. */

/* the generated config header (includes version information) */
#include "gt_config.h"

/* the core module */
#include "core/alphabet_api.h"
#include "core/array2dim_api.h"
#include "core/array_api.h"
#include "core/assert_api.h"
#include "core/basename_api.h"
#include "core/bittab_api.h"
#include "core/bsearch_api.h"
#include "core/countingsort_api.h"
#include "core/cstr_api.h"
#include "core/cstr_table_api.h"
#include "core/dlist_api.h"
#include "core/encseq_api.h"
#include "core/endianess_api.h"
#include "core/error_api.h"
#include "core/file_api.h"
#include "core/fileutils_api.h"
#include "core/fptr_api.h"
#include "core/grep_api.h"
#include "core/hashmap_api.h"
#include "core/init_api.h"
#include "core/interval_tree_api.h"
#include "core/log_api.h"
#include "core/logger_api.h"
#include "core/ma_api.h"
#include "core/msort_api.h"
#include "core/parseutils_api.h"
#include "core/option_api.h"
#include "core/phase_api.h"
#include "core/qsort_r_api.h"
#include "core/queue_api.h"
#include "core/range_api.h"
#include "core/readmode_api.h"
#include "core/splitter_api.h"
#include "core/str_api.h"
#include "core/str_array_api.h"
#include "core/strand_api.h"
#include "core/strcmp_api.h"
#include "core/symbol_api.h"
#include "core/timer_api.h"
#include "core/translator_api.h"
#include "core/types_api.h"
#include "core/undef_api.h"
#include "core/unused_api.h"
#include "core/version_api.h"
#include "core/warning_api.h"
#include "core/xansi_api.h"

/* the extended module */
#include "extended/add_introns_stream_api.h"
#include "extended/bed_in_stream_api.h"
#include "extended/comment_node_api.h"
#include "extended/csa_stream_api.h"
#include "extended/cds_stream_api.h"
#include "extended/eof_node_api.h"
#include "extended/extract_feature_stream_api.h"
#include "extended/feature_node_api.h"
#include "extended/feature_node_iterator_api.h"
#include "extended/genome_node_api.h"
#include "extended/gff3_in_stream_api.h"
#include "extended/gff3_out_stream_api.h"
#include "extended/gff3_parser_api.h"
#include "extended/gff3_visitor_api.h"
#include "extended/gtf_in_stream_api.h"
#include "extended/id_to_md5_stream_api.h"
#include "extended/inter_feature_stream_api.h"
#include "extended/md5_to_id_stream_api.h"
#include "extended/merge_feature_stream_api.h"
#include "extended/merge_stream_api.h"
#include "extended/node_stream_api.h"
#include "extended/node_visitor_api.h"
#include "extended/region_mapping_api.h"
#include "extended/region_node_api.h"
#include "extended/select_stream_api.h"
#include "extended/sequence_node_api.h"
#include "extended/sort_stream_api.h"
#include "extended/stat_stream_api.h"
#include "extended/tag_value_map_api.h"
#include "extended/type_checker_api.h"
#include "extended/type_checker_obo_api.h"
#include "extended/uniq_stream_api.h"
#include "extended/visitor_stream_api.h"

#ifndef WITHOUT_CAIRO
/* the AnnotationSketch module (depends on Cairo) */
#include "annotationsketch/block_api.h"
#include "annotationsketch/canvas_api.h"
#include "annotationsketch/canvas_cairo_context_api.h"
#include "annotationsketch/canvas_cairo_file_api.h"
#include "annotationsketch/color_api.h"
#include "annotationsketch/custom_track_api.h"
#include "annotationsketch/custom_track_gc_content_api.h"
#include "annotationsketch/custom_track_script_wrapper_api.h"
#include "annotationsketch/diagram_api.h"
#include "annotationsketch/feature_index_api.h"
#include "annotationsketch/feature_index_memory_api.h"
#include "annotationsketch/graphics_api.h"
#include "annotationsketch/image_info_api.h"
#include "annotationsketch/layout_api.h"
#include "annotationsketch/rec_map_api.h"
#include "annotationsketch/style_api.h"
#include "annotationsketch/text_width_calculator_api.h"
#include "annotationsketch/text_width_calculator_cairo_api.h"
#endif

#endif
