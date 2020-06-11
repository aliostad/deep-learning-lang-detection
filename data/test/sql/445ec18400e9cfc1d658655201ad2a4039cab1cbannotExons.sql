
select distinct s.run_sample_id,s.chrom,s.pos,a.gene,a.aa_change,r.snvgene,r.mutation_aa
from ghm_snp s, reported_variants_20150407 r,
(select chrom,pos,gene,aa_change from gh_annotation_ss4 
 where aa_change!='' group by chrom,pos,gene,aa_change) a 
where run_sample_id=:s1 
and (read_f_a+read_r_a+read_overlap_a*2+read_f_c+read_r_c+read_overlap_c*2+read_f_g+read_r_g+read_overlap_g*2+read_f_t+read_r_t+read_overlap_t*2<1000) 
and s.chrom=a.chrom and a.pos=s.pos 
and a.gene = r.snvgene and a.aa_change=r.mutation_aa;

