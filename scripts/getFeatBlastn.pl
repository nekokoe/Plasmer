$usage=<<__USAGE__;

$0 input.fasta input.blastn.fmt6 > output.feature

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
#CP045019.1_1    G1BWP2  99.7    288     1       0       1       288     1       288     5.94e-210       578
#CP036372.1      AP014804|MOBP   88.494  478     39      14      40241   40710   1       470     2.59e-160       564

while (<IN>){
    next if (/^#/);
    chomp;
    
    ($qseqid,$sseqid,$pident,$length,$mismatch,$gapopen,$qstart,$qend,$sstart,$send,$evalue,$bitscore) = split /\t/; 
    
    #hard cutoff
    next if ($bitscore < 30 || $evalue > 0.001 || $pident < 85); 

    $seq = $qseqid;

    if ($evalue > 0){
        $evalueLog = -(log($evalue)/log(10));
    }else{
        $evalueLog = 310;
    }

    if ($evalueLog > $evalue{$seq}->{$sseqid} || !defined $evalue{$seq}->{$sseqid}){
        $evalue{$seq}->{$sseqid}=$evalueLog;
    }

}

close IN;

print "#id\tavgEvalueLog\tmaxEvalueLog\tPresence\n";
foreach $seq(sort keys %seqID){

    $sum = 0;
    $max = 0;
    $count = 0;
    foreach $sseqid(keys %{$evalue{$seq}}){
        $sum += $evalue{$seq}->{$sseqid};
        $max = ($evalue{$seq}->{$sseqid} > $max)?$evalue{$seq}->{$sseqid}:$max;
        $count ++;
    }

    $avgEvalueLog = ($count > 0)?($sum / $count):0;
    $maxEvalueLog = $max;
    $presence = ($maxEvalueLog >= 50)?1:0;
        
    print "$seq\t$avgEvalueLog\t$maxEvalueLog\t$presence\n";
}
