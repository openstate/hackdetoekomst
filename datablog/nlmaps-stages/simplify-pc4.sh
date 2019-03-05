#!/bin/bash

# Zipcode information:
# https://www.pdok.nl/introductie?articleid=1953003
# in the atom feed (https://geodata.nationaalgeoregister.nl/cbspostcode4/atom/cbspostcode4.xml)
# you can find the CBS_PC4_2017.zip with ESRI shape file.

# fetch
curl -O 'http://geodata.nationaalgeoregister.nl/cbspostcode4/extract/CBS_PC4_2017.zip'

# unzip needed files
unzip -j -o 'CBS_PC4_*.zip' 'CBS_PC4_*.sh[px]' 'CBS_PC4_*.dbf' -d .

# convert ESRI shape EPSG:28992 (RDnew X/Y) to EPSG:4326 (WGS84 Lat/Lng) GeoJSON
ogr2ogr -s_srs EPSG:28992 -t_srs EPSG:4326 -lco COORDINATE_PRECISION=5 -f GeoJSON cbs_pc4_2017.geo.json CBS_PC4_2017_v1.shp

# simplify topology to make the file small enought to make it usable in the browser
# using TopoJSON https://github.com/topojson/topojson
geo2topo cbs_pc4_2017.geo.json | toposimplify -p 0.0000005 > cbs_pc4_2017.simplified.topo.json && topo2geo -i cbs_pc4_2017.simplified.topo.json cbs_pc4_2017.geo.json

# optional, strip properties to shave off some MBs, this can also do this with "ogr2ogr -select X,Y"
# using JQ https://stedolan.github.io/jq/
# see what keys are there:
jq '.features[0].properties|keys' cbs_pc4_2017.geo.json

# e.g. only keep the PC4 and INWONER properties
jq '.features|=map(.properties|={PC4,INWONER})' cbs_pc4_2017.geo.json -c > cbs_pc4_2017-stripped.geo.json
