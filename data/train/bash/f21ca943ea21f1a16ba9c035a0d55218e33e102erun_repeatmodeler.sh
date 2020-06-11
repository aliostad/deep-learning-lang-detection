#path to your RepeatModeler instance
RepeatModelerPath=/nfs/panda/ensemblgenomes/development/ernesto/bin/RepeatModeler
#Fasta file with genome that will be annotated
genome_file=/nfs/panda/ensemblgenomes/development/ernesto/GLOSSINIDAE/data/g_brevipalpis/genome/g_brevipalpis.fa
#Folder that will hold the different Fasta chunks
genome_file_split_dir_10=/nfs/panda/ensemblgenomes/development/ernesto/GLOSSINIDAE/results/g_brevipalpis/REPEATMODELER_2/fasta_split
#prefix for your species
species_prefix=g_brevipalpis
###

mkdir -p ${genome_file_split_dir_10}

#with --chunk argument you control the number of chunks
fastasplit \
  --fasta ${genome_file} \
  --output ${genome_file_split_dir_10} \
  --chunk 10 \

function get_suffix_from_file_name {
    file=$1
    echo $file | perl -e "<STDIN>=~/(chunk_\d+)/; print \$1;"
}

for chunk in ${genome_file_split_dir_10}/*
do
    file_suffix=`get_suffix_from_file_name $chunk`
    cmd="${RepeatModelerPath}/BuildDatabase -name ${species_prefix}_${file_suffix} ${chunk}"
    echo Running: $cmd
    $cmd
done

for chunk in ${genome_file_split_dir_10}/*
do
    file_suffix=`get_suffix_from_file_name $chunk`   
    cmd="bsub ${RepeatModelerPath}/RepeatModeler -database ${species_prefix}_${file_suffix} 2>repeatmodeler_${file_suffix}.stderr.txt >repeatmodeler_${file_suffix}.stdout.txt"
    echo Running: $cmd
    $cmd
done