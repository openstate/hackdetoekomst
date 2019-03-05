#!/bin/bash

# Municipality information:
# https://www.pdok.nl/introductie?articleid=1953085
# in the atom feed (http://geodata.nationaalgeoregister.nl/wijkenbuurten2018/atom/wijkenbuurten2018.xml)
# you can find the wijkenbuurten2018.zip with ESRI shape file.

# fetch
curl -O 'http://geodata.nationaalgeoregister.nl/wijkenbuurten2018/extract/wijkenbuurten2018.zip'

# unzip needed files
unzip -j -o 'wijkenbuurten*.zip' '*/gem_*.sh[px]' '*/gem_*.dbf' -d .

# convert ESRI shape EPSG:28992 (RDnew X/Y) to EPSG:4326 (WGS84 Lat/Lng) GeoJSON, exclude water area's
ogr2ogr -where "WATER='NEE'" -s_srs EPSG:28992 -t_srs EPSG:4326 -lco COORDINATE_PRECISION=5 -f GeoJSON gem_2018.geo.json gem_2018.shp

# simplify topology to make the file small enought to make it usable in the browser
# using TopoJSON https://github.com/topojson/topojson
geo2topo gem_2018.geo.json | toposimplify -p 0.00005 -f -F > gem_2018.simplified.topo.json && topo2geo -i gem_2018.simplified.topo.json gem_2018.geo.json

# optional, strip properties to shave off some MBs, this can also do this with "ogr2ogr -select X,Y"
# using JQ https://stedolan.github.io/jq/
# see what keys are there:
jq '.features[0].properties|keys' gem_2018.geo.json

# e.g. only keep the GM_NAAM and GM_CODE properties
jq '.features|=map(.properties|={GM_NAAM,GM_CODE})' gem_2018.geo.json -c > gem_2018-stripped.geo.json
