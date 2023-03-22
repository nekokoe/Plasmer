#!/bin/bash

mkdir -p $PREFIX/bin

cp -r scripts/assign_taxon_labels.R	$PREFIX/bin/assign_taxon_labels.R
cp -r scripts/check_length_by_input.py	$PREFIX/bin/check_length_by_input.py
cp -r scripts/customizedKraken2DB_check.sh	$PREFIX/bin/customizedKraken2DB_check.sh
cp -r scripts/extract_predPlasmids_seqs.py	$PREFIX/bin/extract_predPlasmids_seqs.py
cp -r scripts/getFeatBlastn.pl	$PREFIX/bin/getFeatBlastn.pl
cp -r scripts/getFeatDomTbl.pl	$PREFIX/bin/getFeatDomTbl.pl
cp -r scripts/getFeatMDS.pl	$PREFIX/bin/getFeatMDS.pl
cp -r scripts/getFeatRiboRNA.pl	$PREFIX/bin/getFeatRiboRNA.pl
cp -r scripts/mergeFeatsPredict.R	$PREFIX/bin/mergeFeatsPredict.R
cp -r scripts/Plasmer	$PREFIX/bin/Plasmer
cp -r scripts/plasmerMainDB_check.sh	$PREFIX/bin/plasmerMainDB_check.sh
cp -r scripts/predict_by_rpmodel.R	$PREFIX/bin/predict_by_rpmodel.R