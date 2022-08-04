#! /usr/bin/perl
# databasecreator.pl

use XML::Simple;
use Data::Dumper;

print "What is the name of your file? ";
$variable = <STDIN>;
chomp ($variable);
$file = $variable . ".xml";

$xml = new XML::Simple;
$data = $xml->XMLin($file, SearchPath => ['.']);
open OUT, '>transfer.txt' or die $!;
print OUT Dumper($data);

$file = $variable . "." . "txt";
open FILE1, '<transfer.txt' or die $!;
open OUT1, ">$file" or die $!;

while ($line = <FILE1>)
{
	$line =~ s/ /#/g;
	print OUT1 $line;
}

open FILE2, "<$file" or die $!;
open OUT2, '>outfile.txt' or die $!;

while ($line = <FILE2>)
{
	chomp ($line);
	if ($line =~ /(#{84}'Hit_num'#=>#'.+',)/)
	{
		$nums = substr($line, 98, 2);
		if ($nums =~ /(')/)
		{
			print OUT2 substr($line, 98, 1), "  ";
		}
		else
		{
			print OUT2 substr($line, 98, 2), " ";
		}
	}
	elsif ($line =~ /(#{84}'Hit_accession'#=>#'NR_......',)/)
	{
		print OUT2 substr($line, 104, 9), " ";
	}
	elsif ($line =~ /(#{84}'Hit_def'#=>#')/)
	{
		$HitDef = substr($line, 98, 100);
		$HitDef =~ s/#/ /g;
		$HitDef =~ s/\'//g;
		print OUT2 $HitDef, "\n";
	}
}
