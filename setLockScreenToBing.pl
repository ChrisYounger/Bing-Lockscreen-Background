#!perl

use strict;
use warnings;
use WWW::Mechanize;
use Data::Dumper;
use POSIX qw(mktime);
use JSON::PP;
use Encode;
use URI::Encode qw(uri_encode uri_decode);
use Email::Send;
use Email::Send::Gmail;
use Email::Simple::Creator;
  
my ($day, $month, $year) = (gmtime())[3,4,5];
my $today = sprintf("%04d-%02d-%02d", ($year+1900), ($month+1), $day);

my $mech = WWW::Mechanize->new();

$mech->get("http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-AU");

=pod

{"images":[
{"startdate":"20151111","fullstartdate":"201511111300","enddate":"20151112","url":"/az/hprichbg/rb/WhiteBluffsWilderness_EN-AU12259474431_1920x1080.jpg","urlbase":"/az/hprichbg/rb/WhiteBluffsWilderness_EN-AU12259474431","copyright":"White Bluffs wilderness, Washington (© Jon Cornforth/Danita Delimont)","copyrightlink":"http://www.bing.com/search?q=White+Bluffs,+Washington&form=hpcapt","wp":true,"hsh":"990d9f13960fd2beaef2ca6474573eac","drk":1,"top":1,"bot":1,"hs":[],"msg":[{"title":"You'd call our bluff","link":"http://www.bing.com/images/search?q=White+Bluffs+North+Slope+Washington&FORM=pgbar1","text":"If we called this place white"},{"title":"Trending trailers","link":"http://www.bing.com/videos?FORM=pgbar2","text":"See what everyone's watching"}]}
],"tooltips":{"loading":"Loading...","previous":"Previous","next":"Next","walle":"This image is not available to download as wallpaper.","walls":"Download this image. Use of this image is restricted to wallpaper only."}}

=cut

my $content = $mech->response()->decoded_content();
print $content . "\n\n";
$content =~ s/[^[:ascii:]]/ /g;

my $json = decode_json($content);
my $image_url = "http://bing.com" . $json->{images}[0]{url};
print "Getting daily image " . $image_url . " and saving to " . $today . ".jpg\n";

$image_url =~ s/_1920x1080/_1366x768/;  # need to request the smaller image becuase lock screen images have to be small
$mech->get($image_url);

$mech->save_content("C:\\Windows\\System32\\oobe\\info\\backgrounds\\backgroundDefault.jpg");
$mech->save_content("C:\\Windows\\System32\\oobe\\info\\backgrounds\\background_" . $today  . ".jpg");

__DATA__

my $encoded = uri_encode($image_url);

my $email = Email::Simple->create(
	header => [
		From    => 'chris.younger@gmail.com',
		To      => 'chris.younger@gmail.com',
		Subject => "Daily Background - $today",
	],
	body => "Light Background:\n\n" .
			"https://mail.google.com/mail/?tm=1#settings/themes/customlight?" . $encoded . "\n\n" .
			"Dark Background:\n\n" .
			"https://mail.google.com/mail/?tm=1#settings/themes/customdark?" . $encoded . "\n",
);
my $sender = Email::Send->new({   
	mailer      => 'Gmail',
	mailer_args => [
		username => 'chris.younger@gmail.com',
		password => 'baateywfcqhbljkm',
	]
});
eval { $sender->send($email) };
die "Error sending email: $@" if $@;

__DATA__

https://mail.google.com/mail/?tm=1#settings/themes/customdark?http%3A%2F%2Fbing.com%2Faz%2Fhprichbg%2Frb%2FDanyangKorea_EN-AU10759282379_1366x768.jpg

die Dumper($json);
https://mail.google.com/mail/#settings/themes/customlight? url encode

https://mail.google.com/mail/#settings/themes/customlight?http%3A%2F%2Fwww.gmailskins.com%2Fserve%3Fid%3DAMIfv95OO6AWBy7yf5KA7BLEJYCh0uIQj7hWmMd-YAkB8VtsOZHM4xPOwm-4WVFYSranE0izsmuv5tVzV16rCmZRyNnqgCgKoQdBF2Iya5SJMR8mR9xt8aKmgNl-krXMr2Qr-xRDqwIQx_6-CuvW4iWVJihItoPUpWcBuaL_5kYO_FkrWdQpVYc%26w%3D1600

https://mail.google.com/mail/#settings/themes/customdark?http%3A%2F%2Fwww.gmailskins.com%2Fserve%3Fid%3DAMIfv95OO6AWBy7yf5KA7BLEJYCh0uIQj7hWmMd-YAkB8VtsOZHM4xPOwm-4WVFYSranE0izsmuv5tVzV16rCmZRyNnqgCgKoQdBF2Iya5SJMR8mR9xt8aKmgNl-krXMr2Qr-xRDqwIQx_6-CuvW4iWVJihItoPUpWcBuaL_5kYO_FkrWdQpVYc%26w%3D1600