#!/usr/bin/perl
use 5.001 ; use strict ; use warnings ; 
use bigint ; 
my $t0 ; # starting time
my @argv ; # The original @ARGV  before getopts function executed.
use Getopt::Std ; getopts 'n:uDv' , \my %o ; 
use Time::HiRes qw [gettimeofday tv_interval] ; 
use Term::ANSIColor qw [ :constants ] ; $Term::ANSIColor::AUTORESET = 1 ; 
use FindBin qw [ $Script ] ;
BEGIN { $t0 = [ gettimeofday ] ; @argv = @ARGV } ; 
END {my $sec = tv_interval $t0 ; print STDERR CYAN "[ $Script @argv] spent seconds : $sec\n" }
$o{n} //= 1 ; 

do { & toy ; exit 0 } unless $o{D} ;
& D ; 

sub D { 
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
  -n N  ; Specify the number n ; 
  -u    ; N =  1 .. N 
  -D    ; about that problem ;
  -v    ; verbose mode ;