#!/usr/bin/perl -w
#
#输入exon文件,从中提取uniq intron文件
#
my $in = shift || die $!;
open IN, $in;
#my $tag = "1";
my $dataframe;
my $tagname = "1026";
my $step = 1;
my $repIndi = 0;
while ( <IN> ) {
#	my $dataframe;
	chomp;
	my ($chr,$strand,$startS,$endS,$geneName,$refid)=(split /\t/,$_)[0,1,3,4,5,-1];
	#print "step/geneName/tagname:$step/$geneName/$tagname\n";
	if ($tagname eq $geneName ){
		if ($dataframe){
			$dataframe = $dataframe . &dataframe_builder($chr,$startS,$endS,$geneName,$strand);
		}
		else{
			$dataframe = &dataframe_builder($chr,$startS,$endS,$geneName,$strand);
		}
		if (eof){
			#print "$dataframe";
			$repIndi = &dataframe_sort_uniqer($dataframe);
		}
	}
	elsif ($tagname ne $geneName){
		#print "$dataframe" if ($dataframe);
		$repIndi = &dataframe_sort_uniqer($dataframe) if ($dataframe);

		$dataframe = &dataframe_builder($chr,$startS,$endS,$geneName,$strand);
		$tagname = $geneName;
		if (eof){
			#print "==\n$dataframe";
			$repIndi = &dataframe_sort_uniqer($dataframe);

		}
	}
	

	$step ++;
}

sub dataframe_builder {
	my ($chr,$startS,$endS,$geneName,$strand) = @_;
	my @startS = split /,/,$startS;
	my @endS = split /,/,$endS;
	my $frame;
		for ( my $j = 0; $j <= @startS - 2; $j ++  ) {
			my $subframe = "$chr\t$endS[$j]\t$startS[$j+1]\t$geneName\t0\t$strand\n";
			if ($frame){
				$frame = $frame . $subframe;
			}
			else{
				$frame =  $subframe;
			}
		}
	$frame;
}


sub dataframe_sort_uniqer{
#模块3 positions sort uniq
#输入的是针对某一个基因的一连串intron/exon位置并去除重复位置的操作
#my $dataframe = "1\t2\n1\t2\n1\t2\n1\t2\n1\t2\n3\t4\n1\t3\n";
	my ($inputdataframe) = @_;
	my $outinfo;
	
	chomp( my $dir = `pwd`); 
#print $dir."\n";
	my $tmpout = $dir."/"."tmp.file";
#print $tmpout ."\n";
	open TMPOUT,">$tmpout" || die $!;
	print TMPOUT "$inputdataframe" ;
	my $uniqPoses = `sort -k1,1 -k6 -k2,2n -k3,3n  $tmpout | uniq `;
	@uniqPoses = (split /\n/,$uniqPoses);
	for (my $i = 0;$i<=@uniqPoses-1;$i++){
			#print $outinfo = "$chr\t$uniqPoses[$i]\t$geneName\t0\t$strand\n";
			print $outinfo = "$uniqPoses[$i]\n";
	}
	close TMPOUT;
	my $return = 1;
	return;
}
