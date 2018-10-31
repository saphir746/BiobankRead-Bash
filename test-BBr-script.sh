#!/bin/bash


$WORK=<somewhere>

# UKb input data
CSV_path=$WORK/ukb4528.csv
HTML_path=$WORK/ukb4528.html
TSV_path=$WORK/ukb_HES_236.tsv

# Variables and conditions
varList=$WORK/vars_test.txt ##("'Age assessment'" "'BMI'") ###$WORK/BBR/vars_test.txt 
filterList=$WORK/filters_test.txt  #("Age assessment>50" "Age assessment<70" "BMI>=23" "BMI<=30")
HES_codes=$WORK/ICD10_codes.txt
Death_codes=$HES_codes
SR_things=$WORK/SR_disease.txt
Withdrawn=$WORK/withdrawn_eids.csv

# Output
outname=test_hpc
outname_HES=test_hpc_HES
outname_death=test_hpc_dead
outname_SR=test_hpc_SR
# Construct script path and arguments

source activate py36
# environment previously created with Conda to install Python 3.6 and all the dependencies of BiobankRead

python extract_variables.py \
	--csv $CSV_path \
	--html $HTML_path \
	--vars $varList \
	--excl $Withdrawn \
        #--filter $filterList \
        #--remove_outliers 'True' \
        #--baseline_only 'False' \
	--out $outname &

python HES_extract.py \
	--csv $CSV_path \
        --html $HTML_path \
	--tsv $TSV_path \
	--codes $HES_codes \
	--codeType 'ICD10' \
	--dateTpe 'epistart' \
	--excl $Withdrawn \
	##--firstvisit 'True' \
        ##--baseline 'True' \
	--out $outname_HES &

python extract_death.py \
        --csv $CSV_path \
        --html $HTML_path \
	--codes $Death_codes \
	--excl $Withdrawn \
	##--primary 'True' \
        ##--secondary 'False' \
	--out $outname_death &


python extract_SR.py \
        --csv $CSV_path \
        --html $HTML_path \
	--disease $SR_things \
	--SRcancer 'True' \
	--excl $Withdrawn \
	--out $outname_SR &

# all results in .csv format







