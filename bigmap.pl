#!/usr/bin/perl
# Generated by BigMap 2. Permalink: http://bigmap.osmz.ru/bigmap.php?xmin=136388&xmax=136427&ymin=86999&ymax=87038&zoom=18&scale=256&tiles=landscape

use strict;
use LWP;
use GD;

my ($zoom, $xmin, $ymin, $xmax, $ymax) = (18, 136388, 86999, 136427, 87038);
my @layers = ('http://{abc}.tile3.opencyclemap.org/landscape/!z/!x/!y.png');
my $attribution = 'Map data (c) OpenStreetMap, Tiles (c) Andy Allan';
my $xsize = $xmax - $xmin + 1;
my $ysize = $ymax - $ymin + 1;

my $img = GD::Image->new($xsize*256, $ysize*256, 1);
my $white = $img->colorAllocate(248,248,248);
$img->filledRectangle(0,0,$xsize*256,$ysize*256,$white);
my $ua = LWP::UserAgent->new();
$ua->env_proxy;
$ua->agent('BigMap/2.0');
my $count = 0;
for (my $x=0;$x<$xsize;$x++)
{
    for (my $y=0;$y<$ysize;$y++)
    {
		my $xx = $x + $xmin;
		my $yy = $y + $ymin;
		foreach my $base(@layers)
		{
			my $url = $base;
			$url =~ s/!z/$zoom/g;
			$url =~ s/!x/$xx/g;
			$url =~ s/!y/$yy/g;
			$url =~ s/{([a-z0-9]+)}/substr($1,int(rand(length($1))),1)/e;
			print STDERR "$url... ";
			my $resp = $ua->get($url);
			print STDERR $resp->status_line;
			print STDERR "\n";
			next unless $resp->is_success;
			my $tile = GD::Image->new($resp->content);
			next if ($tile->width == 1);
			if ($base =~ /seamark/) {
			my $black=$tile->colorClosest(0,0,0);
			$tile->transparent($black);
			}
			$img->copy($tile, $x*256,$y*256,0,0,256,256);
			if( ++$count == 10 ) { sleep 2; $count = 0; }
		}
    }
}
my $black = $img->colorClosest(0,0,0);
$img->string(gdSmallFont, 5, $ysize*256 - 15, $attribution, $black);

my @t = localtime();
open PIC, sprintf('>map%02d-%02d%02d%02d-%02d%02d.png', $zoom, $t[5]%100, $t[4]+1, $t[3], $t[2], $t[1]);
binmode PIC;
print PIC $img->png();
close PIC;
