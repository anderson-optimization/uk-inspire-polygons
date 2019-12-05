for file in */*.gml
OGR=docker run -v $(pwd):/tmp/work2 -w /tmp/work2 andersonopt/geoanalysis ogr2ogr
do
 echo "File ${file}"
 if [ -d merged ]
 then
  echo "Appending merged shape"
  OGR -update -append -f "ESRI Shapefile" -t_srs EPSG:4326 merged Abertawe_-_Swansea/Land_Registry_Cadastral_Parcels.gml -s_srs EPSG:27700
 else
  echo "Creating merged shape"
  OGR -f "ESRI Shapefile" -t_srs EPSG:4326 merged Abertawe_-_Swansea/Land_Registry_Cadastral_Parcels.gml -s_srs EPSG:27700
 fi
done