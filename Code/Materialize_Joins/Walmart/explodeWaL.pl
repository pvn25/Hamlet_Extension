#!/usr/bin/perl
open(FIL1, "<all.csv") || die "No\n"; 
#"codeshare","airlineid","sairportid","dairportid","scity","dcity","acountry","dcountry","scountry","ddst","sdst","stimezone","dtimezone","dlongitude","slongitude","eq8","eq17","eq22","name1","eq2","eq1","eq19","eq20","eq28","slatitude","dlatitude","eq46","name4","active","eq3","eq71","eq25","eq30","eq4","eq45","eq14","eq12","name2","eq15","eq31","eq5"
#sid,weekly_sales,dept,store,purchaseid,type,size,temperature_avg,temperature_stdev,fuel_price_avg,fuel_price_stdev,cpi_avg,cpi_stdev,unemployment_avg,unemployment_stdev,holidayfreq
my @dicts = (); #array of dicts for feature domains; each entry is a dict indiv feat vals; later each feat val will be mapped to a linear order of indices per feature for explosion
my @inds = (0,1,2,3,15,16,17,19,20,21,22,23,26,29,30,31,32,33,34,35,36,38,39,40); #Y, XCA
$d = scalar(@inds);
for($i = 0; $i < $d; $i++) {
	my %fdict;
	push(@dicts, %fdict);
}
while (<FIL1>) {
	chomp($_);
	@v = split(/,/,$_); #v[0] is codeshare
	if($v[0] eq "\"codeshare\"") {
		next;
	}
	for($i = 0; $i < $d; $i++) {
		$dicts[$i]{$v[$inds[$i]]} = 1;
	}
}
close(FIL1);
while (<FIL2>) {
	chomp($_);
	@v = split(/,/,$_); #v[0] is codeshare
	if($v[0] eq "\"codeshare\"") {
		next;
	}
	for($i = 0; $i < $d; $i++) {
		$dicts[$i]{$v[$inds[$i]]} = 1;
	}
}
close(FIL2);
@fnames = my ();
while (<FIL3>) {
	chomp($_);
	@v = split(/,/,$_); #v[0] is codeshare
	if($v[0] eq "\"codeshare\"") {
		for($i = 0; $i < $d; $i++) {
			push(@fnames, $v[$inds[$i]]);
		}
		next;
	}
	for($i = 0; $i < $d; $i++) {
		$dicts[$i]{$v[$inds[$i]]} = 1;
	}
}
close(FIL3);
print "num dicts " . scalar(@dicts) . "\n";
print "fnames: @fnames\n";
for($i = 0; $i < $d; $i++) {
	#print "for f $i with name ". $fnames[$i] .", num vals: " . scalar(keys(%{$dicts[$i]})) . "\n";
	$cntr = 1;
	for my $k (sort(keys(%{$dicts[$i]}))) {
		$dicts[$i]{$k} = $cntr;
		#print "\t$k: $cntr, ";
		$cntr = $cntr + 1;
	}
	#print "\n";
}
#read ho; emit the sparsematrix format entries for each tuple: (row,col,val), where row/col start from 1; y can be obtained as such from orig train!
open(FILho, "<".$ARGV[0]) || die "No\n";
open(FILhox, ">".$ARGV[1]) || die "No\n";
$row = 1;
while (<FILho>) {
	chomp($_);
	@v = split(/,/,$_); 
	if($v[0] eq "\"codeshare\"") {
		print FILhox "row,col,val\n";
		next;
	}
	$col = 0;
	for($i = 1; $i < $d; $i++) { #features in X have col names from 1, cum adding up indiv domain sizes
		for my $k (keys(%{$dicts[$i]})) {
			if($v[$inds[$i]] eq $k) {
				print FILhox "$row,".($col + $dicts[$i]{$k}).",1\n";
			}
		}
		$col = $col + scalar(keys(%{$dicts[$i]}));
	}
	$row = $row + 1;
}
close(FILho);
close(FILhox);
