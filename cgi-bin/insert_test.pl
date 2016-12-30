#!/Applications/XAMPP/xamppfiles/bin/perl

# INCLUDES


use strict;
use warnings;

use DBI;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use base 'HTTP::Response';

use XML::Writer;
use XML::Simple;
use DBD::mysql;
use Encode qw(encode decode);

use feature 'say';


#use DMR::CGI;

### TEST
my $enc = 'utf-8';
my $q = CGI->new;
my $hr = new HTTP::Response(" ");
my $xs = XML::Simple->new;

### receive xml package


my @params = $q->param(); #only works for http post? Because param contains HTTP body

my $table = $q->param($params[0]);
my $language =  $q->param($params[1]);
my $translation = $q->param($params[2]);
my $voc1 = decode($enc, $q->param($params[3]));
my $voc2 = decode($enc, $q->param($params[4]));

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
	    $q->header();
	    print '<?xml version="1.0" encoding="UTF-8" ?>';
	 }
}
else{
	print $q->header('text/xml');
	print "server: no parameters received...";
}

### db access & sql calls

my $dsn = "DBI:mysql:database=test;host=localhost";
my $user     = "root";
my $password = "";
my $dbh = DBI->connect($dsn, $user, $password, {
PrintError       => 0,
RaiseError       => 1,
AutoCommit       => 1,
FetchHashKeyName => 'NAME_lc',
mysql_enable_utf8 => 1
});
if ($DBI::errstr)
{
	print $DBI::errstr;
}
#database check if entry already exists
my $sql = 'SELECT distinct english FROM ' . $table . ' WHERE english = "' . $voc1 . '" AND deutsch = "' . $voc2 . '"';
my $sth = $dbh->prepare($sql);
$sth->execute();
my @row = $sth->fetchrow_array;
if (@row || @row != undef){
	sendError("Entry: '" . $voc1 . "' - '" . $voc2 . "' already exists.");
	exit;
}
# TODO check $sth->err

# database insertion
$sql = 'INSERT INTO ' . $table . ' (' . $translation . ', ' . $language . ', create_date) VALUES ("' . $voc2 . '", "' . $voc1 . '", CURRENT_DATE)';
# print $sql . "\n\n";
$sth = $dbh->prepare($sql);
$sth->execute;




# database queries and responses
$sql = 'SELECT english, deutsch FROM ' . $table . ' WHERE id >= ? AND id < ?';
$sth = $dbh->prepare($sql);
# $sth->execute(0, 15);
 print "<p>
    	<table>
    	<tr>
    		<td>english</td> <td>deutsch</td>
    	</tr>";
# while (my @row = $sth->fetchrow_array) {
#    print "	<tr>
#    			<td>$row[0]</td> <td>$row[1]</td>
#    		</tr>";
#}
 
$sth->execute(0, 100);
while (my $row = $sth->fetchrow_hashref) {
   print "	<tr>
    			<td>$row->{english}</td> <td>$row->{deutsch}</td>
    		</tr>";
}
print "</table>
    	</p>";


 
$dbh->disconnect;

sub sendError{
	my $msg = shift;
	my $q = CGI->new;
	my $hr = new HTTP::Response(" ");
	my $xs = XML::Simple->new;
	my $err = {
		err_message => [$msg]
		};
	$hr->message($xs->XMLout($err, KeyAttr => 'error'));
	print $q->header('text/xml');
	print $hr->as_string(); 
	exit;
}


###