#!/usr/bin/perl -w
#根据table提取的bed文件,注意其格式不是BED12
#起始和终止位置信息是BED格式
#
#产生的exon文件会携带上游exon位置的较大值,下游exon位置的较小值.
#
#标准输出在终端上,方便与bash其他命令进行管道操作
#
my $in = shift;
die $! unless ($in);
open IN, $in;
while (<IN> ) {
	chomp;
#hg18.knownGene.chrom	hg18.knownGene.strand	hg18.knownGene.exonCount	hg18.knownGene.exonStarts	hg18.knownGene.exonEnds	hg18.kgXref.geneSymbol	hg18.kgXref.refseq
#这是我从table里提出的数据信息
#
	#部分基因没有refid,为了防止报错以及强迫症所以用-1来赋值refid
	#如果$geneName和$refid一样则表示这个基因没有refid
	my ($chr,$strand,$startS,$endS,$geneName,$refid)=(split /\t/,$_)[0,1,3,4,5,-1];
	my @startS = split /,/,$startS;
	my @endS = split /,/,$endS;
	#第一个exon和最后一个exon没有flanking exon的信息
	#故for循环里$i起始值为1, 末了值需要减去2
	for ( $i = 1; $i <= @startS - 2 ; $i ++) {
		my $exonStart = $startS[$i];
		my $exonEnd = $endS[$i];
		my $exonLeftSite = $endS[$i-1];
		my $exonRightSite= $startS[$i+1];
		print "$chr\t$exonStart\t$exonEnd\t$geneName,$refid\t$exonLeftSite,$exonRightSite\t$strand\n";
	}

}
