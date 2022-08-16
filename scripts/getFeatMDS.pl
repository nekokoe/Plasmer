$usage=<<__USAGE__;

$0 input.fasta input.dmnd.fmt6 mps.tsv > output.feature

current feature : seqID avgRDSscore avgEvalueLog 

__USAGE__

$fasta = shift @ARGV;
$in = shift @ARGV;
$mps = shift @ARGV;

open FA,"<","$fasta" || die "$!\n$usage";
while (<FA>){
    if (/^>(\S+)/){
        $seqID{$1}++;
    }
}
close FA;

open MPS,"<","$mps" || die "$!\n$usage";
#A0A0N0TGX9      Transcriptional regulator       253     -0.219824
while (<MPS>){
	next if (/^#/);
    chomp;
	($id,$function,$unknow,$rds) = split/\t/;
	$rdsRef{$id}=$rds;
}
close MPS;


open IN,"<","$in" || die "$!\n$usage";
#CP045019.1_1    G1BWP2  99.7    288     1       0       1       288     1       288     5.94e-210       578

while (<IN>){
    next if (/^#/);
    chomp;
    ($qseqid,$sseqid,$pident,$length,$mismatch,$gapopen,$qstart,$qend,$sstart,$send,$evalue,$bitscore) = split /\t/; 
    
    #hard cutoff
    next if ($bitscore < 30 || $evalue > 0.001 || $pident < 50); 

    if ($qseqid=~/(\S+)_\d+$/){
        $seq=$1;
    }else{
        next;
    }

    if ($evalue > 0){
        $evalueLog = -(log($evalue)/log(10));
    }else{
        $evalueLog = 310;
    }

    $rdsScore = $rdsRef{$sseqid};

    if ($evalueLog > $evalue{$seq}->{$qseqid} || !defined $evalue{$seq}->{$qseqid}){
        $evalue{$seq}->{$qseqid}=$evalueLog;
        $rds{$seq}->{$qseqid}=$rdsScore;
    }

}

close IN;

print "#id\tavgRDSscore\tmaxRDSscore\tBias\n";
foreach $seq(sort keys %seqID){
    $sum = 0;
    $max = 0;
    $count = 0;
    foreach $qseqid(keys %{$rds{$seq}}){
        $sum += $rds{$seq}->{$qseqid};
        $max = (abs($rds{$seq}->{$qseqid}) > abs($max))?$rds{$seq}->{$qseqid}:$max;
        $count ++;
    }

    $avgRDS = ($count > 0)?($sum / $count):0;
    $maxRDS = $max;

    if ($avgRDS >= 5){
        $bias = 1;
    }elsif ($avgRDS <= -10){
        $bias = -1;
    }else{
        $bias = 0;
    }


#    $sum = 0;
#    $count = 0;
#    foreach $qseqid(keys %{$evalue{$seq}}){
#        $sum += $evalue{$seq}->{$qseqid};
#        $count ++;
#    }    

#    $avgEvalueLog = ($count > 0)?($sum / $count):0;


    print "$seq\t$avgRDS\t$maxRDS\t$bias\n";
}
