#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);

my $num_args = @ARGV;
my $ERROR = 0;

sub get_status {
    if (-d "/proc/sys/net/ipv4/conf/tun0") {
        say '${color4}On${color}';
    }
    elsif (-d "/proc/sys/net/ipv4/conf/ppp0") {
        say '${color4}On${color}';
    }
    else {
        say '${color}Off${color}';
    }
}

sub get_connection {
    my $con = qx{nmcli -t -f name,type,device con | grep vpn | grep eth0};
    my ($name, $type, $dev) = split /:/, $con;
    if (length($name) > 1){
        say $name;
    }
    else {
        say " ";
    }
}

sub error1 {
    return <<END;
ERROR1 has been triggered!
this error is called because you have called the script without its required arguments

Arguments to use:
con  -  con will retrieve your vpn server connection name
stat -  stat will get the connection status of your vpn (On or Off)
END
}

sub error2 {
    return <<END;
ERROR2 has been triggered!
this error is called because you have entered a incorrect argument

Arguments to use:
con  -  con will retrieve your vpn server connection name
stat -  stat will get the connection status of your vpn (On or Off)
END
}

sub errors {

    if ($ERROR != 0) {
        my $file = "conky VPNlog.txt";
        if (-f $file) { qx{rm $file}; }

        open(my $fh, ">> $file") or do { warn "could not open $file: $!"; exit; };

        if ($ERROR == 1) {
            print $fh error1;
        }
        else
        {
            print $fh error2;
        }
        # close the file.
        close $fh;
    }
}

if ($num_args != 1) {
    say '${color3}ERROR!!${color}';
    $ERROR=1;
    errors;
    exit;
}
else {
    if ($ARGV[0] eq "con") {
    	get_connection;
    }
    elsif ($ARGV[0] eq "stat") {
    	get_status;
    }
    else {
        say '${color3}ERROR!!!${color}';
        $ERROR=2;
        errors;
        exit;
    }
}
