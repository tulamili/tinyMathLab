#!/usr/bin/perl
use 5.001 ; use strict ; use warnings ; 
use bigint ; 
my $t0 ; # starting time
my @argv ; # The original @ARGV  before getopts function executed.
use Getopt::Std ; getopts 'n:uUv' , \my %o ; 
use Time::HiRes qw [gettimeofday tv_interval] ; 
use Term::ANSIColor qw [ :constants ] ; $Term::ANSIColor::AUTORESET = 1 ; 
use FindBin qw [ $Script ] ;
BEGIN { $t0 = [ gettimeofday ] ; @argv = @ARGV } ; 
END {my $sec = tv_interval $t0 ; print STDERR CYAN "[ $Script @argv] spent seconds : $sec\n" }
$o{n} //= 1 ; 

do { & toy ; exit 0 } unless $o{U} ;
& UnifQ ; 

sub UnifQ { 
	# init
	my @s ; # $s[x][y][z] 
	my $n = $o{n} ; 
	$s[0][$_][0] = 1 for 0 .. $n ;
	$s[$_][0][($_+1)/2] = 1 for 1 .. $n ;
	# main
	for my $y ( 1 .. $n ) { 
		for my $x ( 1 .. $n ) { 
			my $f = $x <= $y ? 0 : ($x+$y)%2 ; 
			for my $z ( $f .. $x ) {
				#print STDERR YELLOW "\$x,\$y,\$z,\$f=$x,$y,$z,$f ",
				#$s[$x-1][$y][$z-$f]//0, "\n" unless defined $s[$x][$y-1][$z-$f] ;
				$s[$x][$y][$z] = ( $s[$x-1][$y][$z-$f] // 0 ) + ($s[$x][$y-1][$z-$f] //0 ) ;
			}
		}
	}

	if ( $o{u} ) { 
		print "n\tfrq\tval\n" ;
		for my $d ( 1 .. $o{n} ) { 
			my %B ; # 
			grep { $B{$_} ++ } $s[$d][$d][$_] for 0 .. $d ; 
			print "$d\t$B{$_}\t$_\n" for sort {$a <=> $b } keys %B ;
		}

		exit 0  ;
	}

	do { print $s[$n][$n][$_] //0, "\n" for 0 .. $n ; exit 0 } unless $o{v} ;

	for my $y( 0..$n) { 
		for my $z(0..$n) { 
			print join "\t" , map{ $s[$_][$y][$z] //0 } 0..$n ;
			print "\t;\t"; 	
		}
		print "\n" ;
	}

} 

sub toy { 
	print hh($_) , "\n"  for ($o{u}? 1 : $o{n})   .. $o{n} ;
	print "\n" ;
	return ; 
	sub hh { 
		my $n = $_[0] ;
	    my $t = 1 ; 
	    do { $t *= ($n + $_ ) ; $t /=  $_ } for 1 .. $n ; 
	    return $t  ;
	}
}	

__END__
Options : 
  -U    ; about that problem ; without -U then a toy problem calculating the number of C(2n,n) will be performed.
  -u    ; All cases for 1, 2, 3, .. (up until to) N are checked.
  -n N  ; Specify the number n ; 
  -v    ; verbose mode ;


What the author wants to improve: 
 * Ctrl+C receiving to show the calculation processing status (showing $x and $y), and Ctrl+\ to really stop. Or periodically showing ($x,$y) for each minute.
 * $x and $y loops should be changed into prioritizing processing all ($x,$y) where $x + $y is smaller or min ($x,$y) is smaller.

