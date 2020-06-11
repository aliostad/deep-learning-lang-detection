\o all_positions.txt
select read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2,count(1) from ghm_snp where run_sample_id='A0550101_1' group by 1 order by 1;

-- average all positions
select count(1), 
sum(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2),
avg(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2),
min(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2),
max(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2)
from ghm_snp 
where run_sample_id='A0550101_1';

select count(1), 
sum(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2),
avg(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2),
min(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2),
max(read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2)
from ghm_snp s, (select chrom,pos from gh_annotation_ss4 where aa_change!='' group by chrom,pos) a
where run_sample_id='A0550101_1' and s.chrom=a.chrom and a.pos=s.pos;

\o reads_counts.txt
select count(1) from ghm_snp where read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2<10 and run_sample_id='A0550101_1';


\o reads_counts_exons.txt
select count(1) from ghm_snp s, (select chrom,pos from gh_annotation_ss4 where aa_change!='' group by chrom,pos) a where run_sample_id='A0550101_1' and read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2<10 and s.chrom=a.chrom and a.pos=s.pos;

