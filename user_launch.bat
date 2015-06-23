@ECHO OFF
REM gracelite_launch.bat
REM Lanceur Gracelite optionnel pour assister l'utilisateur dans le declenchement des scripts qu'il souhaite executer. 

TITLE GRACELITE

:OPER
ECHO ________________________________________
ECHO GRACELITE (configuration via config.bat)
ECHO DBINTEG
ECHO - Creer une nouvelle base spatialite dbinteg : IC
ECHO - Importer les donnees de shpcsv-in dans dbinteg (via ogr2ogr) : II
ECHO - Exporter les donnees de dbinteg dans shpcsv-out : IE
ECHO - Creer un dump SQL de dbinteg : ID
ECHO DBPROD
ECHO - Creer une nouvelle base spatialite dbprod : PC
ECHO - Importer les donnees de shpcsv-in dans dbprod (via ogr2ogr) : PI
ECHO - Exporter les donnees de dbprod dans shpcsv-out : PE
ECHO GENERAL
ECHO - AIDE : H
ECHO - Quitter : Q
ECHO ________________________________________
SET /P CHOIX="Entrer le code de l'operation :"

IF /I %CHOIX%==IC (CALL user_dbinteg_create.bat)
IF /I %CHOIX%==II (CALL user_dbinteg_shpcsv-in_insert_ogr2ogr.bat)
IF /I %CHOIX%==IE (CALL user_dbinteg_shpcsv-out_spatialite.bat)
IF /I %CHOIX%==IP (CALL user_dbinteg_dump.bat)
IF /I %CHOIX%==PC (CALL admin_dbprod_create.bat)
IF /I %CHOIX%==PI (CALL admin_dbprod_shpcsv-in_insert_ogr2ogr.bat)
IF /I %CHOIX%==PE (CALL admin_dbprod_shpcsv-out_spatialite.bat)
IF /I %CHOIX%==PP (CALL admin_dbinteg_dump.bat)
IF /I %CHOIX%==H (TYPE .\doc\gracelite_aide.txt && PAUSE)
IF /I %CHOIX%==Q (EXIT)

GOTO:OPER
