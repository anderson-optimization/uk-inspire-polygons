for file in */*.gml
do
 echo "File ${file}"
 if [ -d merged ]
 then
  echo "Appending merged shape"
  ogr2ogr -update -append -f "ESRI Shapefile" -t_srs EPSG:4326 merged Abertawe_-_Swansea/Land_Registry_Cadastral_Parcels.gml -s_srs EPSG:27700
 else
  echo "Creating merged shape"
  ogr2ogr -f "ESRI Shapefile" -t_srs EPSG:4326 merged Abertawe_-_Swansea/Land_Registry_Cadastral_Parcels.gml -s_srs EPSG:27700
 fi
done