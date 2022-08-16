$usage=<<__USAGE__;

$0 input.fasta input.domtbl > output.feature

current feature : seqID avgScorePerLength avgEvalueLog

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
    
    @F=split /\s+/; 
    #$query=$F[3];  #for hmmscan
    $query=$F[0];   #for hmmsearch
    $qlen=$F[5];
    $evalue=$F[6];
    $score=$F[7];

    #hard cutoff
    next if ($score < 30 || $evalue > 0.00001); 

    if ($query=~/(\S+)_\d+$/){
        $seq=$1;
    }else{
        next;
    }

    $scorePerLength = $score / $qlen;
    if ($evalue > 0){
        $evalueLog = -(log($evalue)/log(10));
    }else{
        $evalueLog = 310;
    }

    if ($scorePerLength > $score{$seq}->{$query}){
        $score{$seq}->{$query}=$scorePerLength;
    }
    if ($evalueLog > $evalue{$seq}->{$query} || !defined $evalue{$seq}->{$query}){
        $evalue{$seq}->{$query}=$evalueLog;
    }

}
close IN;

print "#id\tavgScore\tavgEvalueLog\tmaxScore\tmaxEvalueLog\tPresence\n";
foreach $seq(sort keys %seqID){
    $sum = 0;
    $max = 0;
    $count = 0;
    foreach $query(keys %{$score{$seq}}){
        $sum += $score{$seq}->{$query};
        $max = ($score{$seq}->{$query} > $max)?$score{$seq}->{$query}:$max;
        $count ++;
    }
    
    $avgScore = ($count > 0)?($sum / $count):0;
    $maxScore = $max;

    $sum = 0;
    $max = 0;
    $count = 0;
    foreach $query(keys %{$evalue{$seq}}){
        $sum += $evalue{$seq}->{$query};
        $max = ($evalue{$seq}->{$query} > $max)?$evalue{$seq}->{$query}:$max;
        $count ++;
    }    

    $avgEvalue = ($count > 0)?($sum / $count):0;
    $maxEvalue = $max;

    $presence = ($maxEvalue >= 50)?1:0;

    print "$seq\t$avgScore\t$avgEvalue\t$maxScore\t$maxEvalue\t$presence\n";
}