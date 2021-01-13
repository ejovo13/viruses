#!/usr/bin/perl
use strict; 
use warnings;

#Check if perl modules are installed, and if they are, install them



use LWP::Simple;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use WWW::Mechanize; #Module used to crawl the web.
    
#pass pdb_id as the first argument	
my $pdb_id = $ARGV[0]; 

#AU variables
my $au_download_link = "http://viperdb.scripps.edu/resources/VDB/${pdb_id}.vdb.gz";
my $au_zip = $pdb_id . ".vdb.gz";
my $au_unzip = $pdb_id . ".pdb";

#FULL variables
my $full_zip = $pdb_id. "_full.vdb.gz";
my $full_unzip = $pdb_id . "_full.pdb";
my $full_download_link = "http://viperdb.scripps.edu/resources/OLIGOMERS/${pdb_id}_full.vdb.gz";

#Download full virus if true
my $download_full = 0;
my $num_args = $#ARGV + 1;

#Download full virus if we pass "full" as the second parameter
if ($num_args > 1) {
	if (lc($ARGV[1]) eq lc("full")) {
		$download_full = 1;
	} else {
		$download_full = 0;
	}
}

if ($download_full) {
	print "Downloading full virus\n";
	getstore($full_download_link, $full_zip);
	gunzip $full_zip => $full_unzip or die "gunzip failed: $GunzipError\n";
	unlink($full_zip);
	print "Full virus downloaded and unzipped\n";
	
} else {
	print "Downloading au\n";
	getstore($au_download_link, $au_zip);
	gunzip $au_zip => $au_unzip or die "gunzip failed: $GunzipError\n";
	unlink($au_zip);
	print "AU virus downloaded and unzipped\n";
}


