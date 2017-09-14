#!/usr/bin/perl
open(FIL, "<all2.csv") || die "No\n"; #wttrain has all uniq vals; no need for ts, ho
#sid,weekly_sales,dept,store,purchaseid,type,size,temperature_avg,temperature_stdev,fuel_price_avg,fuel_price_stdev,cpi_avg,cpi_stdev,unemployment_avg,unemployment_stdev,holidayfreq
my @dicts = (); #array of dicts for feature domains; each entry is a dict indiv feat vals; later each feat val will be mapped to a linear order of indices per feature for explosion
#my @inds = (0,1,2,3,15,16,17,19,20,21,22,23,26,29,30,31,32,33,34,35,36,38,39,40); 
$d = 1 + 21; #Y, |X|
$max = 0;
for($i = 0; $i < $d; $i++) {
	my %fdict;
	push(@dicts, %fdict);
}
while (<FIL>) {
	chomp($_);
	@v = split(/,/,$_); #v[0] is sid, v[1] is weekly_sales - both are ignored
	if($v[0] eq "sid") {
		next;
	}
	for($i = 0; $i < $d; $i++) {
		$dicts[$i]{$v[1 + $i]} = 1;
	}
}
#print "num dicts" . scalar(@dicts) . "\n";
for($i = 0; $i < $d; $i++) {
	print "for f $i, num vals: " . scalar(keys(%{$dicts[$i]})) . "\n";
	if($i != 0){
		$max = $max + scalar(keys(%{$dicts[$i]}));
	}
	$cntr = 1;
	#for my $k (keys(%{$dicts[$i]})) { #this gave non-deterministic key ordering!
	for my $k (sort(keys(%{$dicts[$i]}))) {
		$dicts[$i]{$k} = $cntr;
		#print "$cntr \n";
		$cntr = $cntr + 1;
	}
}

close(FIL);

#read tr, ts, and ho; emit the sparsematrix format entries for each tuple: (row,col,val), where row/col start from 1; y can be obtained as such from orig wttrain!
open(FILtr, "<".$ARGV[0]) || die "No1\n";
open(FILtrx, ">".$ARGV[1]) || die "No3\n";
$row = 1;
while (<FILtr>) {
	chomp($_);
	@v = split(/,/,$_); #v[0] is sid, v[1] is weekly_sales - both are ignored
	if($v[0] eq "sid") {
		print FILtrx "row,col,val\n";
		next;
	}
	$col = 0;
	for($i = 1; $i < $d; $i++) { #features in X have col names from 1, cum adding up indiv domain sizes
		for my $k (keys(%{$dicts[$i]})) {
			if($v[1 + $i] eq $k) {
				print FILtrx "$row,".($col + $dicts[$i]{$k}).",1\n";
			}
		}
		$col = $col + scalar(keys(%{$dicts[$i]}));
	}
	for($i = 23; $i < 42; $i++) {
		print FILtrx "$row,".($i + $max + 1 - 23).",$v[$i]\n";
	}
	$row = $row + 1;
}
close(FILtr);
close(FILtrx);
