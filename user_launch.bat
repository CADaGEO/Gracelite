@ECHO OFF
REM gracelite_launch.bat
REM Lanceur Gracelite optionnel pour assister l'utilisateur dans le declenchement des scripts qu'il souhaite executer. 

TITLE Gracelite
CALL config.bat

:OPER
%GLSFK% echo "[yellow]________________________________________[def]"
%GLSFK% echo "[yellow]GRACELITE (configuration via config.bat)[def]"
ECHO GENERAL
%GLSFK% echo "- Aide : [green]H[def]"
%GLSFK% echo "- Configuration : [green]C[def]"
%GLSFK% echo "- Quitter : [green]Q[def]"
ECHO DBINTEG
%GLSFK% echo "- Creer une nouvelle base spatialite dbinteg : [green]IC[def]"
%GLSFK% echo "- Importer les donnees de shpcsv-in dans dbinteg (via ogr2ogr) : [green]II[def]"
%GLSFK% echo "- Exporter les donnees de dbinteg dans shpcsv-out : [green]IE[def]"
%GLSFK% echo "- Creer un dump SQL de dbinteg : [green]IP[def]"
ECHO DBPROD
%GLSFK% echo "- Creer une nouvelle base spatialite dbprod : [green]PC[def]"
%GLSFK% echo "- Importer les donnees de shpcsv-in dans dbprod (via ogr2ogr) : [green]PI[def]"
%GLSFK% echo "- Exporter les donnees de dbprod dans shpcsv-out : [green]PE[def]"
%GLSFK% echo "- Creer un dump SQL de dbprod : [green]PP[def]"

%GLSFK% echo "[yellow]________________________________________[def]"
SET /P CHOIX="Code de l'operation a executer :"

IF /I %CHOIX%==H (TYPE .\doc\gracelite_aide.txt | more && PAUSE)
IF /I %CHOIX%==C (ECHO Configurer en priorite la ligne "SET GLOSGEOPATH=" avec le chemin d'installation de QGIS && PAUSE && %GLNOTEPAD% config.bat)
IF /I %CHOIX%==Q (EXIT)
IF /I %CHOIX%==IC (CALL user_dbinteg_create.bat)
IF /I %CHOIX%==II (CALL user_dbinteg_shpcsv-in_insert_ogr2ogr.bat)
IF /I %CHOIX%==IE (CALL user_dbinteg_shpcsv-out_spatialite.bat)
IF /I %CHOIX%==IP (CALL user_dbinteg_dump.bat)
IF /I %CHOIX%==PC (CALL admin_dbprod_create.bat)
IF /I %CHOIX%==PI (CALL admin_dbprod_shpcsv-in_insert_ogr2ogr.bat)
IF /I %CHOIX%==PE (CALL admin_dbprod_shpcsv-out_spatialite.bat)
IF /I %CHOIX%==PP (CALL admin_dbinteg_dump.bat)


GOTO:OPER
