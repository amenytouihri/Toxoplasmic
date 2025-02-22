#!/usr/bin/env bash
#SBATCH --time=02:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=featurecount
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/featurecount_%J.out
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/featurecount_%J.err
#SBATCH --partition=pibu_el8


#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq_course"                          # Working directory
LOGDIR="$WORKDIR/log"                                                  # Log directory
OUTDIR="$WORKDIR/counts"                                         # Output directory
ANNOTATIONFILE="$WORKDIR/processed_data/reference_genome/Mus_musculus.GRCm39.113.gtf"               # Annotation file
MAPPINGDIR="$WORKDIR/mapping"                                      # Mapping directory
SAMPLELIST="$WORKDIR/samples/sample_list.txt"  # Sample list


#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

mkdir -p $OUTDIR

#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

apptainer exec --bind $WORKDIR /containers/apptainer/subread_2.0.1--hed695b0_0.sif featureCounts -T4 -p -s2 -Q10 -t exon -g gene_id -a $ANNOTATIONFILE -o "$OUTDIR/gene_count.txt" $MAPPINGDIR/*sorted.bam
