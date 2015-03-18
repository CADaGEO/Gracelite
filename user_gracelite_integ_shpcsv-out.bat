@ECHO OFF
:VARIABLES
REM SET SPLEX=..\..\bin\spatialite41\spatialite.exe
REM SET SPLEX=..\..\tools\spatialite42\spatialite.exe
SET SPLEX=spatialite.exe
SET SPLDB=.\dbinteg\gracelite_integ.sqlite
SET SHPCSVOUT=.\shpcsv-out\

:EXPORTSHP
SET SHPOUT=Cable
SET SPLTBL=t_cable
SET SPLTYPE=LINESTRING
spatialite_tool -e -shp %SHPCSVOUT%%SHPOUT% -d %SPLDB% -t %SPLTBL% -g Geometry -c CP1252 --type %SPLTYPE%

SET SHPOUT=Ebp
SET SPLTBL=t_ebp
SET SPLTYPE=POINT
spatialite_tool -e -shp %SHPCSVOUT%%SHPOUT% -d %SPLDB% -t %SPLTBL% -g Geometry -c CP1252 --type %SPLTYPE%

PAUSE
