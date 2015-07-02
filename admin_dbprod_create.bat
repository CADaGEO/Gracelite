@ECHO OFF

REM Gracelite/gracelite_dbprod_create.bat
REM Version : 0.01
REM ALENO
REM CREATION DE LA BASE gracelite_prod.sqlite
REM Licence : GNU GPLv3
REM 23/06/2015 - SBY - aleno.eu : CREATION DU SCRIPT
REM Cible spatialite

ECHO CREATION DE LA BASE gracelite_prod.sqlite
PAUSE

:LAUNCH
CALL:CONFIG
CALL:BASE
CALL:SCHEMA
PAUSE
GOTO:EOF

:CONFIG
CALL config.bat
GOTO:EOF

:BASE
ECHO SUPPRESSION BASE
IF EXIST %GLDBPROD% DEL /s %GLDBPROD%

ECHO CREATION BASE
%GLSPLEX% %GLDBPROD% "PRAGMA foreign_keys = ON;"

GOTO:EOF


:SCHEMA
ECHO GRACELITE - CREATION DE LA STRUCTURE DE LA BASE DE DONNEES
ECHO GRACELITE - CREATION DES LISTES
SET FSQL=%GLDBPRODSCHEMA%\gracethd_1_lists.sql
%GLSPLEX% %GLDBPROD% < %FSQL%
ECHO GRACELITE - INSERT VALEURS DANS LES LISTES
SET FSQL=%GLDBPRODSCHEMA%\gracethd_2_insert.sql
%GLSPLEX% %GLDBPROD% < %FSQL%
ECHO GRACELITE - CREATION DES TABLES
SET FSQL=%GLDBPRODSCHEMA%\gracethd_3_tables.sql
%GLSPLEX% %GLDBPROD% < %FSQL%
ECHO GRACELITE - AJOUT DES CHAMPS GEOMETRIQUES
SET FSQL=%GLDBPRODSCHEMA%\gracethd_4_spatialite.sql
%GLSPLEX% %GLDBPROD% < %FSQL%
ECHO GRACELITE - AJOUT DES INDEX
SET FSQL=%GLDBPRODSCHEMA%\gracethd_5_index.sql
%GLSPLEX% %GLDBPROD% < %FSQL%
ECHO GRACELITE - AJOUT DES SPECIFICITES
SET FSQL=%GLDBPRODSCHEMA%\gracethd_6_specifique.sql
%GLSPLEX% %GLDBPROD% < %FSQL%

GOTO:EOF