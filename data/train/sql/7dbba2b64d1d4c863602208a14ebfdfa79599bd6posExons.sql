
-- reported
-- select :s1,count(1) from ghm_snp s, (select chrom,pos from gh_annotation_ss4 where aa_change!='' group by chrom,pos) a where run_sample_id=:s1 and (read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2<1000) and s.chrom=a.chrom and a.pos=s.pos group by 1;

select :s1,count(distinct concat(s.chrom,',',s.pos) ) from ghm_snp s, (select chrom,pos from gh_annotation_ss4 where aa_change!='' group by chrom,pos) a where run_sample_id=:s1 and (read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2<1000) and s.chrom=a.chrom and a.pos=s.pos group by 1;

