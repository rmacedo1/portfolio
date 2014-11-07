#!/usr/bin/perl -w

my $debug=0; # default - will be overriden by a form parameter or cookie
my @sqlinput=();
my @sqloutput=();

use strict;
use CGI qw(:standard);
use DBI;
use Time::ParseDate;

my $dbuser="rmx035";
my $dppasswd ="zwpG66Qtv";

my $cookiename="PortSession";
my $debugcookiename="PortDebug";
#
## Get the session input and debug cookies, if any
##
my $inputcookiecontent = cookie($cookiename);
my $inputdebugcookiecontent = cookie($debugcookiename);

my $outputcookiecontent = undef;
my $outputdebugcookiecontent = undef;
my $deletecookie=0;
my $user = undef;
my $password = undef;
my $logincomplain=0;


my $action;
#action can be login, logout, base, register, getstats, strategy, getsymb (displ ay history and 
# createport, deleteport, getport, recstock (record new stock info either by     user input or by pulling from service), 
my $run;


if (defined(param("act"))) { 
  $action=param("act");
  if (defined(param("run"))) { 
    $run = param("run") == 1;
  } else {
    $run = 0;
  }
} else {
  $action="base";
  $run = 1;
}


my $dstr;

if (defined(param("debug"))) { 
  # parameter has priority over cookie
     if (param("debug") == 0) { 
         $debug = 0;
     } else {
         $debug = 1;
     }
} else {
     if (defined($inputdebugcookiecontent)) { 
        $debug = $inputdebugcookiecontent;
     } else {
        # debug default from script
     }
}

$outputdebugcookiecontent=$debug;

if (defined($inputcookiecontent)) {
    ($user, $password) = split(/\//, $inputcookiecontent);
    $outputcookiecontent = $inputcookiecontent;
} else {
    ($user, $password) = ("anon", "anonanon");
}

if ($action eq "login") {
   if ($run) {
	($user, $password) = (param('user'), param('password'));
	if (ValidUser($user,$password)) {
	   $outputcookiecontent=join("/",$user,$password);
	   $action= "base";
	   $run = 1;
         } else {
	    $logincomplain=1;
            $action = "login";
	    $run = 0;
         }
    } else {
       undef $inputcookiecontent;
       ($user,$password)= ("anon","anonanon");
    }
}

if ($action eq "logout") {
   $deletecookie=1;
   $action = "base";
   $user = "anon";
   $password = "anonanon";
   $run = 1;
}

my @outputcookies;

if (defined($outputcookiecontent)) { 
  my $cookie=cookie(-name=>$cookiename,
		    -value=>$outputcookiecontent,
		    -expires=>($deletecookie ? '-1h' : '+1h'));
  push @outputcookies, $cookie;
} 

if (defined($outputdebugcookiecontent)) { 
  my $cookie=cookie(-name=>$debugcookiename,
		    -value=>$outputdebugcookiecontent);
  push @outputcookies, $cookie;
}


##### need to invoke the code we were provided #####

print header(-expires=>'now', -cookie=>\@outputcookies);

print start_html('Portfolio');
print "<html style=\"height: 100\%\">";
print "<head>";
print "<title>Portfolio</title>";
print "</head>";
print "<h1 style=\"text-align:center\">Welcome to My Portfolio!</h1>";

print "<body style=\"height:100\%;margin:0;background-color:lightblue\">";
print "<style type=\"text/css\">\n\@import \"port.css\";\n</style>\n";


#ACTS
#login
#register
#seeports
#strategy
#updatecash
#newport
#getport
#getsymb
#stocktrans
#getstats



print end_html();

#SUBFUNCTIONS-> sql calls

#UserAdd

#ValidUser

#AddPortfolio
#portID, name, numStocks, useremail

#DeletePortfolio

#AddStock
#symb, count, portID

#DeleteStock

#DepositCash

#Widthdraw Cash

#ValidStock

#GetStocks

#GetStockValue -quote ? not needed ?

#GetPortValue

#GetCashAccount

#UpdateStock - insertion into our NewData


#ExecSQL

#sub ExecSQL {
#  my ($user, $passwd, $querystring, $type, @fill) =@_;
#  if ($debug) { 
#    # if we are recording inputs, just push the query string and fill list onto the 
#    # global sqlinput list
#    push @sqlinput, "$querystring (".join(",",map {"'$_'"} @fill).")";
#  }
#  my $dbh = DBI->connect("DBI:Oracle:",$user,$passwd);
#  if (not $dbh) { 
#    # if the connect failed, record the reason to the sqloutput list (if set)
#    # and then die.
#    if ($debug) { 
#      push @sqloutput, "<b>ERROR: Can't connect to the database because of ".$DBI::errstr."</b>";
#    }
#    die "Can't connect to database because of ".$DBI::errstr;
#  }
#  my $sth = $dbh->prepare($querystring);
#  if (not $sth) { 
#    #
#    # If prepare failed, then record reason to sqloutput and then die
#    #
#    if ($debug) { 
#      push @sqloutput, "<b>ERROR: Can't prepare '$querystring' because of ".$DBI::errstr."</b>";
#    }
#    my $errstr="Can't prepare $querystring because of ".$DBI::errstr;
#    $dbh->disconnect();
#    die $errstr;
#  }
#  if (not $sth->execute(@fill)) { 
    #
    # if exec failed, record to sqlout and die.
#    if ($debug) { 
#      push @sqloutput, "<b>ERROR: Can't execute '$querystring' with fill (".join(",",map {"'$_'"} @fill).") because of ".$DBI::errstr."</b>";
#    }
#    my $errstr="Can't execute $querystring with fill (".join(",",map {"'$_'"} @fill).") because of ".$DBI::errstr;
#    $dbh->disconnect();
#    die $errstr;
#  }
  #
  # The rest assumes that the data will be forthcoming.
  #
  #
#  my @data;
#  if (defined $type and $type eq "ROW") { 
#    @data=$sth->fetchrow_array();
#    $sth->finish();
#    if ($debug) {push @sqloutput, MakeTable("debug_sqloutput","ROW",undef,@data);}
#    $dbh->disconnect();
#    return @data;
#  }
#  my @ret;
#  while (@data=$sth->fetchrow_array()) {
#    push @ret, [@data];
#  }
#  if (defined $type and $type eq "COL") { 
#    @data = map {$_->[0]} @ret;
#    $sth->finish();
#    if ($debug) {push @sqloutput, MakeTable("debug_sqloutput","COL",undef,@data);}
#    $dbh->disconnect();
#    return @data;
#  }
#  $sth->finish();
#  if ($debug) {push @sqloutput, MakeTable("debug_sql_output","2D",undef,@ret);}
#  $dbh->disconnect();
#  return @ret;
#}



