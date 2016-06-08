#!C:/xampp/perl/bin/perl

# INCLUDES


use strict;
use warnings;

use DBI;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use base 'HTTP::Response';
use Data::Dumper;

use XML::Writer;
use XML::Simple;

use feature 'say';


#use DMR::CGI;

### TEST
my $q = CGI->new;
my $hr = new HTTP::Response(" ");
my $xs = XML::Simple->new;

### receive xml package


my @params = $q->param();



### send response

# 


if(@params){
     print $q->header;
	 print $params[0];
	 # say for @params;
}
else{
	my $xml = '<?xml version="1.0" encoding="UTF-8"?> <data_body> <table>business_english</table><language>english</language><word1>bias</word1><translation>deutsch</translation><word2>Tendenz</word2></data_body>';
	print $q->header('text/xml');
}


my $outputHash = {
	string => 'Hello from perl',
};

$hr->message($xs->XMLout($outputHash, KeyAttr => 'opt'));
print $hr->as_string(); 

### db access & sql calls

my $dsn = "dbi:mysql:vokabeln@localhost:3306";
my $user     = "root";
my $password = "mn9vt3an10";
my $dbh = DBI->connect($dsn, $user, $password, {
PrintError       => 0,
RaiseError       => 1,
AutoCommit       => 1,
FetchHashKeyName => 'NAME_lc',
});
 
# ...
 
$dbh->disconnect;


###