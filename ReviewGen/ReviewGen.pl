#!/usr/bin/perl
use Net::FTP;
my $destserv="jerboa";
my $destuser="test1";
my $destpass="test11";
my $directory='or-20120523';

# open FTP connection
$ftp=Net::FTP->new($destserv) or die "error connecting\n";
$ftp->login($destuser,$destpass);
$ftp->binary();

# read directory to put files from
opendir(DIR,$directory) or die $!;
while(my $file=readdir(DIR)){
  # put file
  print "$file\n";
  $ftp->put("$directory/$file");
}
closedir(DIR);

# create INI file
open(FIL,">OR.INI") or die "cannot create INI\n";
print FIL "[version]\n";
print FIL "type=or\n";
print FIL "now=20120523_0233\n\n";
print FIL "[source]\n";
print FIL "path=contingency/or\n\n";
print FIL "[destination]\n";
print FIL "path=contingency/or\n";

$ftp->put("OR.INI");

$ftp->quit();


