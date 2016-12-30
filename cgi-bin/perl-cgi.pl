#!/usr/bin/perl -w

use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);


sub output_top($);
sub output_end($);
sub display_results($);
sub output_form($);

my $q = new CGI;

print $q->header();

# Output stylesheet, heading etc
output_top($q);

if ($q->param()) {
    # Parameters are defined, therefore the form has been submitted
    display_results($q);
} else {
    # We're here for the first time, display the form
    output_form($q);
}

# Output footer and end html
output_end($q);

exit 0;

# Outputs the start html tag, stylesheet and heading
sub output_top($) {
    my ($q) = @_;
    print $q->start_html(
        -title => 'A Questionaire',
        -bgcolor => 'white');
}

# Outputs a footer line and end html tags
sub output_end($) {
    my ($q) = @_;
    print $q->div("My Web Form");
    print $q->end_html;
}

# Displays the results of the form
sub display_results($) {
    my ($q) = @_;

    my $username = $q->param('user_name');
    print $q->div($username);
}

# Outputs a web form
sub output_form($) {
    my ($q) = @_;
    print $q->start_form(
        -name => 'main',
        -method => 'POST',
    );

    print $q->start_table;
    print $q->Tr(
      $q->td('Name:'),
      $q->td(
        $q->textfield(-name => "user_name", -size => 50)
      )
    );

    print $q->Tr(
      $q->td($q->submit(-value => 'Submit')),
      $q->td('&nbsp;')
    );
    print $q->end_table;
    print $q->end_form;
}