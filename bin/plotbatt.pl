#! /bin/perl
use Date::Parse;
($ss,$mm,$hh,$day,$month,$year,$zone) = ();
if ($ARGV[0] eq "-f") {
	$mindate = str2time($ARGV[1]);
	shift @ARGV;
	shift @ARGV;
} elsif ($ARGV[0] eq '-h') {
    print <<END;
Tool to parse and plot log file produced by currentwidget Android app.
Parses and prints remaining battery % against time over a 24 hour period.
If you have data for more than 1 day, then automatically plots each day as a 
separate line.
Flags
	-h 			Print this help
	-f 'date spec' 	Takes a date and plots discharge curves only for dates greater than hte given date. 
				Useful if you've been using currentwidget for sometime. Takes a string that Date::Parse 
				can parse - so anything valid there is valid.
END
	exit(1);
}else {
	$mindate = str2time('1/1/1970');
}
my %files=();
while (<>) {
	my @cols = split /,/, $_;
	my $date = str2time($cols[0]);
	my $lastday = $day;
	($ss,$mm,$hh,$day,$month,$year,$zone) = strptime($cols[0]);
	$month = $month + 1;
	if ($lastday != $day  && $date > $mindate) {
		close (FILE);
		my $fname = "/tmp/batt$month$day.dat";
		$files{"$day-$month"}= $fname;
		open FILE, '>', $fname;
#		print "$cols[0], $month, $day \n";
	}
	if ($date > $mindate) {
		print FILE "$hh:$mm $cols[2]\n";	
		}
	# print $date;
}

my $gnuplotScript = <<END;
set terminal png size 1200,800
set output "load.png"
set xdata time
set timefmt "%H:%M"
# time range must be in same format as data file
set xrange ["00:00":"23:59"]
set yrange [0:110]
set xtics format "%H" 
set xtics 3600
set xlabel "Time"
set ylabel "Battery"
set ytics 0,5
set title "Time"
set grid
#set key left box
END
$plot="";
foreach (sort keys %files) {
	$plot=$plot.",'$files{$_}' using 1:2 title \"$_\" with lines lw 2";
}
$plot=substr $plot, 1;
$gnuplotScript= "gnuplot <<INPUT\n".$gnuplotScript."plot ".$plot."\nINPUT\n";
system($gnuplotScript);
