#!/usr/bin/perl -w
#
# 移除第四行记录的所有关于gene的注释信息
# 以方便获得uniq intron数据集
#
#
#会标准输出在终端上, 以方便在管道里与wc -l , uniq等命令一起输出
#所以保存文件时请用>命令
#
use strict;

my $in = shift; 
die $! unless ($in); 

open IN, $in;

while ( <IN> ) {
	chomp;
	#移除的方法就是只筛选其他列的数据
	#而不包含第四列的基因注释信息
	my ($chr,$start,$end, $signal, $strand) = (split /\t/, $_)[0,1,2,4,5];
	print "$chr\t$start\t$end\t0\t$signal\t$strand\n";
}
