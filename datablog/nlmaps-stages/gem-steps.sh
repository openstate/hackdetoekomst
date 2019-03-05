#!/bin/bash

# See LibreOffice after some manual steps, copy the name + value columns and execute the following:
xsel | jq -Rs 'split("\n")|map(split("\t")|select(.[0])|{key:.[0],value:.[1]|tonumber})|from_entries' > gmnaam_banen_lookup.json

cat Instelling_woonplaats_stageplaats.csv | csvjson --stream -y 0 | jq -s 'map({gm_code:((10000+.stage_gemeentecode)|tostring|"GM"+.[1:5]),aantal:.Aantal_Studenten})|group_by(.gm_code)|map(.[0]+{aantal:map(.aantal)|add})|map({key:.gm_code,value:.aantal})|from_entries' > gmcode_stages_lookup.json

jq '.features|=map(.properties|=(.+{STAGES:$s[0][.GM_CODE],BANEN:$b[0][.GM_NAAM]}))' --slurpfile b gmnaam_banen_lookup.json --slurpfile s gmcode_stages_lookup.json gem_2018-stripped.geo.json -c > gem.geo.json

(echo -n "var data=";cat gem.geo.json;echo ";")>gem.geo.json.js
