# scripts to process impute2 output
while read -r line
do 
  s3cmd get s3://bioinformatics_scratch/zhenyu/impute2/chunk.$line/chunk.$line.impute2 & 
done < "chunk"


while read -r line
do 
  s3cmd get s3://bioinformatics_scratch/zhenyu/impute2/chunk.$line/chunk.$line.impute2_info  & 
done < "chunk"


for chr in `seq 1 22`
do 
  f=chunk.$chr
  echo $f
  while read -r chunk
  do
    echo $chunk
    awk '$7>=0.4 {print $2}' chunk.$chunk.impute2_info >> $chr.keep        
    plink19 --gen chunk.$chunk.impute2 --sample tcga.sample --oxford-single-chr $chr --out $chunk         
  done < $f
done   


while read -r chr bfile bfilelist extract
do
	plink --noweb --bfile $bfile --merge-list $bfilelist --extract $extract --make-bed --out chr$chr &
done < "master.txt"

for i in `seq 1 22`
do
  plink --noweb --bfile ../impute2/chr$i --hwe 0.001 --maf 0.02 --extract biallelic.snps --make-bed --out chr$i &
done


output = matrix(NA, 22, 4)
for(i in 1:22){
 c = chunk[which(grepl(paste0("chr",i,"\\."), chunk$chunk)), "chunk"]
 f = paste0("~/chunk/merge.", i)
 bfile = c[1]
 other = c[-1]
 mlist = cbind(paste0(other, ".bed"), paste0(other, ".bim"), paste0(other, ".fam")) 
 write.table(mlist, f, col.names=F, row.names=F, quote=F, sep="\t")
 output[i,] = c(i, bfile, paste0("merge.", i), paste0(i, ".keep"))
 }
 
