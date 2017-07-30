#!/usr/bin/perl
use feature qw(say);
use File::Copy qw(copy);

installBinaries();
fileConfigs();
installOracle();

sub installBinaries{
$installBins= `apt-get install build-essential zip unzip -y`;
say "Done..";
}

sub fileConfigs{
say "Setting Configuration File Paths...";
$oracleProfilePath = '$HOME/.oracle_profile';
$bashrcPath = '$HOME/.bashrc';

say "Writing server configuration to: $serverConfPath...";

$oracleProfile = <<"END_MSG";
export ORACLE_BASE=$HOME/opt/Oracle
export ORACLE_HOME=$ORACLE_BASE/instantclient_12_2
export PATH=$ORACLE_HOME:$PATH
export NLS_LANG=American_America.UTF8

# Set LD_LIBRARY_PATH avoiding a final colon.
if [ -z "$LD_LIBRARY_PATH" ]; then
export LD_LIBRARY_PATH=$ORACLE_HOME
else
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
fi
END_MSG
open(my $OUT, '>', "$oracleProfilePath") or die "Could not open file '$oracleProfilePath' $!";
say $OUT "$oracleProfile";

$bashrc = <<"END_MSG";

if [ -f ~/.oracle_profile ]; then
            . ~/.oracle_profile
    fi

END_MSG
open(my $OUT, '>>', "$bashrcPath") or die "Could not open file '$bashrcPath' $!";
say $OUT "$bashrc";
close $OUT;

}


sub installOracle{
$OraclePath = '$HOME/opt/Oracle';
$CreateOracleFolder = `mkdir -p $OraclePath`;
$getOraclebins = `wget -O instantclient_12_2.zip https://www.dropbox.com/s/xl81035pz47q39j/instantclient_12_2.zip?dl=0`;
$InstallClient = `unzip instantclient_12_2.zip -d $OraclePath`;

$untarDbdOracle = `tar xzf DBD-Oracle-1.74.tar.gz`;
$make = `cd ./DBD-Oracle-1.74/ && perl Makefile.PL && make && make install`;
}

