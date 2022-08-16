$usage=<<__USAGE__;

$0 input.fasta input.cmscan.tblout > output.feature

current feature : seqID avgEvalueLog

__USAGE__

$fasta = shift @ARGV;
$in = shift @ARGV;

open FA,"<","$fasta" || die "$!\n$usage";
while (<FA>){
    if (/^>(\S+)/){
        $seqID{$1}++;
    }
}
close FA;

open IN,"<","$in" || die "$!\n$usage";

while (<IN>){
    next if (/^#/);
    chomp;
    
	#1    LSU_rRNA_bacteria    RF02541   CP069828.1_sliding:1400001-1600000 -         -          cm        1     2925   173274   170373      -    no    1 0.53  41.9 2866.0         0  !   *       -      -      -
    @F=split /\s+/; 
    $target=$F[1];
    $query=$F[3];
    $score=$F[16];
    $evalue=$F[17];

    #hard cutoff
    next if ($score < 30 || $evalue > 0.001); 

    if ($evalue > 0){
        $evalueLog = -(log($evalue)/log(10));
    }else{
        $evalueLog = 310;
    }

    if ($evalueLog > $evalue{$query}->{$target} || !defined $evalue{$query}->{$target}){
        $evalue{$query}->{$target}=$evalueLog;
    }

}
close IN;

print "#id\tavgEvalueLog\tmaxEvalueLog\tPresence\n";
foreach $query(sort keys %seqID){

    $sum = 0;
    $max = 0;
    $count = 0;
    foreach $target(keys %{$evalue{$query}}){
        $sum += $evalue{$query}->{$target};
        $max = ($evalue{$query}->{$target} > $max)?$evalue{$query}->{$target}:$max;
        $count ++;
    }    
	
    $avgEvalueLog = ($count > 0)?($sum / $count):0;
    $maxEvalueLog = $max;
    $presence = ($maxEvalueLog >= 50)?1:0;

	print "$query\t$avgEvalueLog\t$maxEvalueLog\t$presence\n";
}



