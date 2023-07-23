#! /bin/perl

use LWP::UserAgent;
# Format of input file
# memberid,ezlinksuser,ezlinkspass
#
while(<>) {
    my $browser = LWP::UserAgent->new();
    @params = split /,/, $_;
    my $response = $browser->get("https://api.ezlinks.com/ETNObject.asp?DOM=1&Timeout=60&Subscriber=okigolf&Password=bigfoot03&ObjectID=UserGetTeeTimesSummary&Param1=$params[1]&Param2=$params[2]");
    if ($response->content() =~ /INVALID_UPW/ ) {
        print "$params[0]\n";
    }
}
