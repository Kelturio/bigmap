#!/usr/bin/env python
# Generated by BigMap 2. Permalink: http://bigmap.osmz.ru/bigmap.php?xmin=68172&xmax=68235&ymin=43478&ymax=43541&zoom=17&scale=256&tiles=toner

import io, urllib2, datetime, time, re, random
from PIL import Image, ImageDraw
# ^^^^^^ install "python-pillow" package | pip install Pillow | easy_install Pillow

(zoom, xmin, ymin, xmax, ymax) = (17, 68172, 43478, 68235, 43541)
layers = ["http://{abc}.tile.stamen.com/toner/!z/!x/!y.png"]
attribution = 'Map data (c) OpenStreetMap, Tiles (c) Stamen Design'
xsize = xmax - xmin + 1
ysize = ymax - ymin + 1

resultImage = Image.new("RGBA", (xsize * 256, ysize * 256), (0,0,0,0))
counter = 0
for x in range(xmin, xmax+1):
	for y in range(ymin, ymax+1):
		for layer in layers:
			url = layer.replace("!x", str(x)).replace("!y", str(y)).replace("!z", str(zoom))
			match = re.search("{([a-z0-9]+)}", url)
			if match:
				url = url.replace(match.group(0), random.choice(match.group(1)))
			print url, "... ";
			try:
				req = urllib2.Request(url, headers={'User-Agent': 'BigMap/2.0'})
				tile = urllib2.urlopen(req).read()
			except Exception, e:
				print "Error", e
				continue;
			image = Image.open(io.BytesIO(tile))
			resultImage.paste(image, ((x-xmin)*256, (y-ymin)*256), image.convert("RGBA"))
			counter += 1
			if counter == 10:
				time.sleep(2);
				counter = 0

draw = ImageDraw.Draw(resultImage)
draw.text((5, ysize*256-15), attribution, (0,0,0))
del draw

now = datetime.datetime.now()
outputFileName = "map%02d-%02d%02d%02d-%02d%02d.png" % (zoom, now.year % 100, now.month, now.day, now.hour, now.minute)
resultImage.save(outputFileName)
