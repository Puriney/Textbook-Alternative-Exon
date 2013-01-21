#!/usr/bin/perl -w
#输入文件是经过intersecBed处理过后的原始文件
#需要比较exon所携带的上下游exon位置, 与intersect过后intron的起始位置
#如果吻合,则保留为课本意义上的可变剪切exon数据集
#
#

my $in = shift;
die $! unless ($in);
open IN, $in;
while (<IN>){
	chomp;
	my @info = split /\t/, $_;
	#第五列记录着上下游位置信息
	#并以 , 隔开数据
	#$exonsites = $info[4];
	my ($exonLeftSite, $exonRightSite) = (split /,/,$info[4])[0,1];
	#my ($exonLeftSite, $exonRightSite) = (split /,/,$exonsites)[0,1];
	#print "$exonLeftSite-$exonRightSite;";
	my ($intrStart,$intrEnd) = ($info[7],$info[8]);
	if ($exonLeftSite == $intrStart && $exonRightSite == $intrEnd) {
		for (my $i = 0;$i <= 5; $i ++){
			print "$info[$i]\t";
		}
		print "\n";
	}
}
