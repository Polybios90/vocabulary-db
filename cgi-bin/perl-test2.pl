#!C:/xampp/perl/bin/perl

# INCLUDES


use strict;
use warnings;

use DBI;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use base 'HTTP::Response';

use XML::Writer;
use XML::Simple;

use feature 'say';


#use DMR::CGI;

### TEST
my $q = CGI->new;
my $hr = new HTTP::Response(" ");
my $xs = XML::Simple->new;

### receive xml package


my @params = $q->param(); #only works for http post? Because param contains HTTP body

my $table = $q->param($params[0]);



# query request

my %headers = map { $_ => $q->http($_) } $q->http();



# query HTTP request
if(@params){
	 if($params[0] eq '')
	 {
		print $q->header('text/plain');
		print "Got empty HTTP request:\n";
	 }
	 else
	 {
	    print $q->header;
	 	print "<br>$params[0]  =  $table<br>";
		# say for @params;
	 }
}
else{
	my $xml = '<?xml version="1.0" encoding="UTF-8"?> <data_body> <table>business_english</table><language>english</language><word1>bias</word1><translation>deutsch</translation><word2>Tendenz</word2></data_body>';
	print $q->header('text/xml');
	print "server: no parameters received..."
}


my $outputHash = {
	string => 'Hello from perl',
	remark => "extra info",
};

### send xml response response

$hr->message($xs->XMLout($outputHash, KeyAttr => 'opt'));
print $hr->as_string(); 

### db access & sql calls

my $dsn = "dbi:SQLite:vokabeln.sq3";
my $user     = "root";
my $password = "mn9vt3an10";
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

# database queries and responses

my $sql = 'SELECT english, deutsch FROM business_english WHERE id >= ? AND id < ?';
my $sth = $dbh->prepare($sql);
$sth->execute(1, 10);
while (my @row = $sth->fetchrow_array) {
   # print "english: $row[0]  deutsch: $row[1]\n";
}
 
$sth->execute(12, 17);
while (my $row = $sth->fetchrow_hashref) {
   print "english: $row->{english}  deutsch: $row->{deutsch}\n";
}


 
$dbh->disconnect;


###