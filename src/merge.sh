OGR="docker run -v $(pwd):/tmp/work2 -w /tmp/work2 webmapp/gdal-docker ogr2ogr"
OUTPUT=merged.gdb
for file in */*.gml
do
 echo "File ${file}"
 if [ -d ${OUTPUT} ]
 then
  echo "Appending merged shape"
  ${OGR} -update -append -f "FileGDB" -t_srs EPSG:4326 ${OUTPUT} Abertawe_-_Swansea/Land_Registry_Cadastral_Parcels.gml -s_srs EPSG:27700
 else
  echo "Creating merged shape"
  ${OGR} -f "FileGDB" -t_srs EPSG:4326 ${OUTPUT} Abertawe_-_Swansea/Land_Registry_Cadastral_Parcels.gml -s_srs EPSG:27700
 fi
done