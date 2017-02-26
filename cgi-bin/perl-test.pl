#!/Applications/XAMPP/xamppfiles/bin/perl

# INCLUDES


# use strict;
use warnings;

use DBI;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use base 'HTTP::Response';
use Net::Domain qw(hostname hostfqdn hostdomain);

use XML::Writer;
use XML::Simple;
use DBD::mysql;
use Encode qw(encode decode);

use feature 'say';

### TEST
my $q = CGI->new;
my $hr = new HTTP::Response(" ");
my $xs = XML::Simple->new;

### receive xml package


my @params = $q->param(); #only works for http post? Because param contains HTTP body

my $table = $q->param($params[0]);
my $translation =  $q->param($params[1]);
my $german = $q->param($params[2]);
my $voc1 = $q->param($params[3]);
my $voc2 = $q->param($params[4]);

# query request

my %headers = map { $_ => $q->http($_) } $q->http();



# query HTTP request
if(@params){
	 if($params[0] eq '')
	 {
		print $q->header('text/plain');
		print "Got empty http post request!\n";
	 }
	 else
	 {
		print $q->header(	-type=> 'text/html',
							-charset=>'utf-8');
	    # print '<?xml version="1.0" encoding="UTF-8" ?>';
	    # say for @params;
	    print "Received http post parameters...\n";
	 }
}
else{
	# print $q->header();
	# print "server: no parameters received...";
	print $q->header('text/xml');
	# say for @params;

    my $host = "host";
    $host = hostname;
    my $outputHash = {
		string => 'Hello from perl',
		hostname => [ 
						$host
					]
	};
	### db access & sql calls

	my $dsn = "DBI:mysql:database=test;host=localhost";
	my $user     = "root";
	my $password = "";
	my $dbh = DBI->connect($dsn, $user, $password, {
		PrintError       => 0,
		RaiseError       => 1,
		AutoCommit       => 1,
		FetchHashKeyName => 'NAME_lc',
	});
	if ($DBI::errstr)
	{
		print $DBI::errstr;
	}
	my $sth = $dbh->prepare("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA='test'") or die 
	+DBI->errstr;
	$sth->execute() or die $DBI->errstr;

	my %outputHash2;
	my $counter = 1;
	while( my( $table ) = $sth->fetchrow_array() ) {
    	$outputHash2{ "table" . $counter  } = $table;
    	++$counter;
	}

	use Data::Dumper;
	$outputHash = { %$outputHash, %outputHash2 };
#	print Dumper($outputHash);

	# %outputHash = (%outputHash, %outputHash2);
	### send xml response response

	$hr->message($xs->XMLout($outputHash, KeyAttr => 'opt'));
	print $hr->as_string(); 
	exit;
}




