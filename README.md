# UK Inspire Polygons

https://www.gov.uk/government/collections/download-inspire-index-polygons




## Load data


- Issues loading GML files at once using below commands

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

#### Merge data

- Try merging to 1 and then loading

Tried merging to shapefile, hit limits, shapefiles are suppose to be under 2gb, apparently might work until 4/8gb. 

Moved on to fileGdb, which requires a special build of gdal/ogr with filegdb api.

Found docker image with this built `webmapp/gdal-docker`

#### Working with gml

https://github.com/3XE/Land-Registry-INSPIRE-Index-Polygons-tools

```
export GML_GFS_TEMPLATE=Land_Registry_Cadastral_Parcels.gfs
```

schema 
```
<GMLFeatureClassList>
  <GMLFeatureClass>
    <Name>PREDEFINED</Name>
    <ElementPath>PREDEFINED</ElementPath>
    <GeometryType>3</GeometryType>
    <SRSName>urn:ogc:def:crs:EPSG::27700</SRSName>
    <DatasetSpecificInfo>
      <ExtentXMin>0.0</ExtentXMin>
      <ExtentXMax>700000.0</ExtentXMax>
      <ExtentYMin>0.0</ExtentYMin>
      <ExtentYMax>1300000.0</ExtentYMax>
    </DatasetSpecificInfo>
    <PropertyDefn>
      <Name>INSPIREID</Name>
      <ElementPath>INSPIREID</ElementPath>
      <Type>Integer</Type>
    </PropertyDefn>
    <PropertyDefn>
      <Name>LABEL</Name>
      <ElementPath>LABEL</ElementPath>
      <Type>Integer</Type>
    </PropertyDefn>
    <PropertyDefn>
      <Name>NATIONALCADASTRALREFERENCE</Name>
      <ElementPath>NATIONALCADASTRALREFERENCE</ElementPath>
      <Type>Integer</Type>
    </PropertyDefn>
    <PropertyDefn>
      <Name>VALIDFROM</Name>
      <ElementPath>VALIDFROM</ElementPath>
      <Type>String</Type>
      <Width>24</Width>
    </PropertyDefn>
    <PropertyDefn>
      <Name>BEGINLIFESPANVERSION</Name>
      <ElementPath>BEGINLIFESPANVERSION</ElementPath>
      <Type>String</Type>
      <Width>24</Width>
    </PropertyDefn>
  </GMLFeatureClass>
</GMLFeatureClassList>
```