#!/usr/bin/perl  -w 
# step4 optional
# Yun YAN @whu
#去除AS exon里的isoform信息但保留基因名信息
#去除AS exon里的上下游位置信息
#
#最后得到的简化版 必须用BASH命令行去冗余操作
#sort -k1,1 -k6 -k2,2n -k3,3n |uniq
#
#结果打印到终端 方便与管道操作
my $in = shift || die $! ;

open IN, $in;

while (<IN>){
	chomp;
	my $info = $_;
	my @info = split (/\t/, $info);
	my $geneSymbol = $info[3];
	@geneSymbol = split (/,/,$geneSymbol);
	$geneSymbol = $geneSymbol[0];
	#chr start end gene_symbol 0 strand
	print "$info[0]\t$info[1]\t$info[2]\t$geneSymbol\t0\t$info[5]\n";
}

