#!/bin/bash

cat Leerplaatsen.csv | sed 's/NULL//g' | csvjson --stream -y 0 | jq 'group_by(.Postcode)|map({key:.[0].Postcode|tostring,value:map(.aantal_Stages_2018)|add})|from_entries' -s > pclookup.json

jq '.features|=map(.properties|=(.+{STAGES:$l[0][.PC4|tostring]}))' --slurpfile l pclookup.json cbs_pc4_2017-stripped.geo.json -c > pc4.geo.json

(echo -n "var data=";cat pc4.geo.json;echo ";")>pc4.geo.json.js
