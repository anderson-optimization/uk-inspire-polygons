# UK Inspire Polygons

https://www.gov.uk/government/collections/download-inspire-index-polygons




## Load data


- Issues loading GML files at once using below commands
- Try merging to 1 and then loading

#### Init, create table
```
docker run -v $(pwd):/tmp/work2 andersonopt/geoanalysis ogr2ogr -f PostgreSQL  PG:'host=aoassetdb.cpvfmepzslta.us-west-2.rds.amazonaws.com user=eanderson dbname=uk_inspire_polygons password=perfectdriftpilsner' -lco FID=INSPIREID /tmp/work2/init/Abertawe_-_Swansea/Land_Registry_Cadastral_Parcels.gml
```

```
for i in */*.gml;
do 
    echo $i; 
    docker run -v $(pwd):/tmp/work2 andersonopt/geoanalysis ogr2ogr -f PostgreSQL  PG:'host=aoassetdb.cpvfmepzslta.us-west-2.rds.amazonaws.com user=eanderson dbname=uk_inspire_polygons password=perfectdriftpilsner port=5432' --config PG_USE_COPY -update -append -lco FID=INSPIREID /tmp/work2/$i;
    echo "sleeping"
    sleep 60 
    echo "awake"
done
```