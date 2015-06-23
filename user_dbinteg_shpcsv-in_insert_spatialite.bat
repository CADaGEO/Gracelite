REM @ECHO OFF

:LAUNCH
CALL:CONFIG
REM CALL:VARIABLES
REM ECHO GRACELITE - CREATION DE LA BASE. 
REM CALL:BASE
REM PAUSE
CALL:SCHEMA
REM PAUSE
CALL:CONNECTSHP
PAUSE
CALL:CONNECTCSV
PAUSE
CALL:INSSHPCSV
PAUSE
GOTO:EOF

:CONFIG
CALL config.bat
GOTO:EOF

:VARIABLES
SET SPLEX=spatialite.exe --silent
SET SPLDB=.\dbinteg\gracelite_integ.sqlite
SET SHPDB=.\shpcsv-in\
SET SCHEMA=.\sql_spatialite\
SET SHPCODE=CP1252
SET SHPSRID=2154
SET CSVCODE=UTF-8
REM SET CODECSV=CP1252
SET CSVQUOTE=NONE
SET CSVDELIM=;

GOTO:EOF

:BASE
ECHO SUPPRESSION BASE
IF EXIST %SPLDB% DEL /s %SPLDB%

ECHO CREATION BASE
%SPLEX% %SPLDB% "PRAGMA foreign_keys = ON;"

GOTO:EOF


:SCHEMA
ECHO GRACELITE - CREATION DE LA STRUCTURE DE LA BASE DE DONNEES
ECHO GRACELITE - CREATION DES LISTES
SET FSQL=%SCHEMA%gracethd_1_lists.sql
%SPLEX% %SPLDB% < %FSQL%
ECHO GRACELITE - INSERT VALEURS DANS LES LISTES
SET FSQL=%SCHEMA%gracethd_2_insert.sql
%SPLEX% %SPLDB% < %FSQL%
ECHO GRACELITE - CREATION DES TABLES
SET FSQL=%SCHEMA%gracethd_3_tables.sql
%SPLEX% %SPLDB% < %FSQL%
ECHO GRACELITE - AJOUT DES CHAMPS GEOMETRIQUES
SET FSQL=%SCHEMA%gracethd_4_spatialite.sql
%SPLEX% %SPLDB% < %FSQL%
ECHO GRACELITE - AJOUT DES INDEX
SET FSQL=%SCHEMA%gracethd_5_index.sql
%SPLEX% %SPLDB% < %FSQL%
ECHO GRACELITE - AJOUT DES SPECIFICITES
SET FSQL=%SCHEMA%gracethd_6_specifique.sql
%SPLEX% %SPLDB% < %FSQL%

GOTO:EOF

:CONNECTSHP
ECHO DEBUT DE CONNEXION DES SHAPEFILES (TABLES vt_)
REM %SPLEX% %SPLDB% "CREATE VIRTUAL TABLE 'vt_shpsupport' USING VirtualShape('%SHPDB%Les supports', 'CP1252', 2154);"

SET SHP=t_adresse
SET SPLVT=vt_adresse
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_noeud
SET SPLVT=vt_noeud
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_cheminement
SET SPLVT=vt_cheminement
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_cable
SET SPLVT=vt_cable
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_znro
SET SPLVT=vt_znro
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_zsro
SET SPLVT=vt_zsro
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_zpbo
SET SPLVT=vt_zpbo
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_zdep
SET SPLVT=vt_zdep
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_zcoax
SET SPLVT=vt_zcoax
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

SET SHP=t_empreinte
SET SPLVT=vt_empreinte
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualShape('%SHPDB%%SHP%', '%SHPCODE%', %SHPSRID%);"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% %SPLSQL%

ECHO FIN DE CONNEXION DES SHAPEFILES (TABLES vt_)

GOTO:EOF

:CONNECTCSV
ECHO DEBUT DE CONNEXION DES CSV (TABLES vt_)

SET CSV=t_organisme
SET SPLVT=vt_organisme
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_reference
SET SPLVT=vt_reference
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_sitetech
SET SPLVT=vt_sitetech
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_ltech
SET SPLVT=vt_ltech
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_baie
SET SPLVT=vt_baie
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_tiroir
SET SPLVT=vt_tiroir
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_equipement
SET SPLVT=vt_equipement
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_suf
SET SPLVT=vt_suf
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_ptech
SET SPLVT=vt_ptech
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_ebp
SET SPLVT=vt_ebp
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_cassette
SET SPLVT=vt_cassette
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_conduite
SET SPLVT=vt_conduite
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_cond_chem
SET SPLVT=vt_cond_chem
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_masque
SET SPLVT=vt_masque
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_cab_cond
SET SPLVT=vt_cab_cond
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_love
SET SPLVT=vt_love
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_fibre
SET SPLVT=vt_fibre
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_position
SET SPLVT=vt_position
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_ropt
SET SPLVT=vt_ropt
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_siteemission
SET SPLVT=vt_siteemission
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_document
SET SPLVT=vt_document
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

SET CSV=t_docobj
SET SPLVT=vt_docobj
SET SPLSQL="CREATE VIRTUAL TABLE '%SPLVT%' USING VirtualText('%SHPDB%%CSV%.csv', '%CSVCODE%', 1, COMMA, %CSVQUOTE%, '%CSVDELIM%');"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% %SPLSQL%

ECHO FIN DE CONNEXION DES CSV (TABLES vt_)
GOTO:EOF


:INSSHPCSV
ECHO INSERTION DES DONNEES DES SHAPEFILES ET CSV DANS LES TABLES SPATIALITE
REM SET FSQL=gracelite_integ_shpcsv-in.sql
REM %SPLEX% %SPLDB% < %FSQL%

REM TODO : Manque le SET SHPDB a chaque brique. 

IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_adresse SELECT ad_id, ad_code, ad_ban_id, ad_nomvoie, ad_fantoir, ad_numero, ad_rep, ad_insee, ad_postal, ad_alias, ad_nom_ld, ad_x_ban, ad_y_ban, ad_commune, ad_section, ad_idpar, ad_x_parc, ad_y_parc, ad_nat, ad_nblhab, ad_nblpro, ad_nbprhab, ad_nbprpro, ad_rivoli, ad_hexacle, ad_distinf, ad_isole, ad_prio, ad_racc, ad_batcode, ad_nombat, ad_ietat, ad_itypeim, ad_prop, ad_gest, ad_idatsgn, ad_iaccgst, ad_idatcab, ad_typzone, ad_comment, ad_geolqlt, ad_geolmod, ad_geolsrc, ad_creadat, ad_majdate, ad_majsrc, ad_abddate, ad_abdsrc, Geometry FROM vt_adresse;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_organisme SELECT or_code, or_siren, or_nom, or_type, or_activ, or_l331, or_siret, or_nometab, or_ad_code, or_nomvoie, or_numero, or_rep, or_local, or_postal, or_commune, or_telfixe, or_mail, or_comment, or_creadat, or_majdate, or_majsrc, or_abddate, or_abdsrc FROM vt_organisme;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_reference SELECT rf_id, rf_code, rf_type, rf_fabric, rf_design, rf_etat, rf_comment, rf_creadat, rf_majdate, rf_majsrc, rf_abddate, rf_abdsrc FROM vt_reference;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_noeud SELECT nd_id, nd_code, nd_codeext, nd_nom, nd_coderat, nd_r1_code, nd_r2_code, nd_r3_code, nd_r4_code, nd_ad_code, nd_voie, nd_type, nd_type_ep, nd_comment, nd_dtclass, nd_geolqlt, nd_geolmod, nd_geolsrc, nd_creadat, nd_majdate, nd_majsrc, nd_abddate, nd_abdsrc, Geometry FROM vt_noeud;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_sitetech SELECT st_id, st_code, st_nd_code, st_codeext, st_nom, st_prop, st_gest, st_user, st_proptyp, st_statut, st_etat, st_dateins, st_dt_ms, st_typephy, st_typelog, st_nblines, st_ad_code, st_comment, st_creadat, st_majdate, st_majsrc, st_abddate, st_abdsrc FROM vt_sitetech;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_ltech SELECT lt_id, lt_code, lt_codeext, lt_etiquet, lt_st_code, lt_prop, lt_gest, lt_user, lt_proptyp, lt_statut, lt_etat, lt_dateins, lt_datemes, lt_local, lt_elec, lt_clim, lt_occp, lt_idmajic, lt_comment, lt_creadat, lt_majdate, lt_majsrc, lt_abddate, lt_abdsrc FROM vt_ltech;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_baie SELECT ba_id, ba_code, ba_codeext, ba_etiquet, ba_lt_code, ba_prop, ba_gest, ba_user, ba_proptyp, ba_statut, ba_etat, ba_rf_code, ba_type, ba_nb_u, ba_haut, ba_larg, ba_prof, ba_comment, ba_creadat, ba_majdate, ba_majsrc, ba_abddate, ba_abdsrc FROM vt_baie;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_tiroir SELECT ti_id, ti_code, ti_codeext, ti_etiquet, ti_ba_code, ti_prop, ti_etat, ti_type, ti_rf_code, ti_taille, ti_placemt, ti_localis, ti_comment, ti_creadat, ti_majdate, ti_majsrc, ti_abddate, ti_abdsrc FROM vt_tiroir;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_equipement SELECT eq_id, eq_code, eq_codeext, eq_etiquet, eq_ba_code, eq_prop, eq_dateins, eq_datemes, eq_comment, eq_creadat, eq_majdate, eq_majsrc, eq_abddate, eq_abdsrc FROM vt_equipement;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_suf SELECT sf_id, sf_code, sf_nd_code, sf_ad_code, sf_escal, sf_etage, sf_oper, sf_type, sf_prop, sf_resid, sf_local, sf_racco, sf_comment, sf_creadat, sf_majdate, sf_majsrc, sf_abddate, sf_abdsrc FROM vt_suf;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_ptech SELECT pt_id, pt_code, pt_codeext, pt_etiquet, pt_nd_code, pt_prop, pt_gest, pt_user, pt_proptyp, pt_statut, pt_etat, pt_dateins, pt_datemes, pt_typephy, pt_typelog, pt_nature, pt_secu, pt_occp, pt_lignes, pt_a_dan, pt_a_dtetu, pt_a_struc, pt_a_haut, pt_a_passa, pt_a_strat, pt_rotatio, pt_detec, pt_comment, pt_creadat, pt_majdate, pt_majsrc, pt_abddate, pt_abdsrc FROM vt_ptech;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_ebp SELECT bp_id, bp_code, bp_etiquet, bp_codeext, bp_pt_code, bp_lt_code, bp_sf_code, bp_prop, bp_gest, bp_user, bp_proptyp, bp_statut, bp_etat, bp_occp, bp_datemes, bp_typephy, bp_typelog, bp_rf_code, bp_entrees, bp_ref_kit, bp_ca_nb, bp_nb_pas, bp_occup, bp_linecod, bp_oc_code, bp_racco, bp_comment, bp_creadat, bp_majdate, bp_majsrc, bp_abddate, bp_abdsrc FROM vt_ebp;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_cassette SELECT cs_id, cs_code, cs_nb_pas, cs_bp_code, cs_num, cs_type, cs_face, cs_rf_code, cs_comment, cs_creadat, cs_majdate, cs_majsrc, cs_abddate, cs_abdsrc FROM vt_cassette;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_cheminement SELECT cm_id, cm_code, cm_codeext, cm_ndcode1, cm_ndcode2, cm_cm1, cm_cm2, cm_r1_code, cm_r2_code, cm_r3_code, cm_r4_code, cm_voie, cm_gest_vo, cm_pro_voi, cm_statut, cm_etat, cm_datcons, cm_datemes, cm_typelog, cm_typ_imp, cm_nature, cm_compo, cm_cddispo, cm_mod_pos, cm_passage, cm_revet, cm_remblai, cm_charge, cm_larg, cm_fildtec, cm_mut_org, cm_long, cm_lgreel, cm_comment, cm_dtclass, cm_geolqlt, cm_geolmod, cm_geolsrc, cm_creadat, cm_majdate, cm_majsrc, cm_abddate, cm_abdsrc, Geometry FROM vt_cheminement;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_conduite SELECT cd_id, cd_code, cd_codeext, cd_etiquet, cd_cd_code, cd_r1_code, cd_r2_code, cd_r3_code, cd_r4_code, cd_prop, cd_gest, cd_user, cd_proptyp, cd_statut, cd_etat, cd_dateaig, cd_dateman, cd_datemes, cd_type, cd_dia_int, cd_dia_ext, cd_color, cd_long, cd_nbcable, cd_occup, cd_comment, cd_creadat, cd_majdate, cd_majsrc, cd_abddate, cd_abdsrc FROM vt_conduite;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_cond_chem SELECT dm_cd_code, dm_cm_code, dm_creadat, dm_majdate, dm_majsrc, dm_abddate, dm_abdsrc FROM vt_cond_chem;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_masque SELECT mq_id, mq_nd_code, mq_face, mq_col, mq_ligne, mq_cd_code, mq_qualinf, mq_comment, mq_creadat, mq_majdate, mq_majsrc, mq_abddate, mq_abdsrc FROM vt_masque;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_cable SELECT cb_id, cb_code, cb_codeext, cb_etiquet, cb_bp1, cb_bp2, cb_r1_code, cb_r2_code, cb_r3_code, cb_r4_code, cb_prop, cb_gest, cb_user, cb_proptyp, cb_statut, cb_etat, cb_dateins, cb_datemes, cb_tech, cb_type, cb_rf_id, cb_capafo, cb_fo_disp, cb_modulo, cb_diam, cb_color, cb_long, cb_lgreel, cb_comment, cb_dtclass, cb_geolqlt, cb_geolmod, cb_geolsrc, cb_creadat, cb_majdate, cb_majsrc, cb_abddate, cb_abdsrc, Geometry FROM vt_cable;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_cab_cond SELECT cc_cb_code, cc_cd_code, cc_creadat, cc_majdate, cc_majsrc, cc_abddate, cc_abdsrc FROM vt_cab_cond;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_love SELECT lv_id, lv_cb_code, lv_nd_code, lv_long, lv_creadat, lv_majdate, lv_majsrc, lv_abddate, lv_abdsrc FROM vt_love;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_fibre SELECT fo_id, fo_code, fo_code_ext, fo_cb_code, fo_nincab, fo_numtub, fo_nintub, fo_type, fo_etat, fo_color, fo_reper, fo_proptyp, fo_comment, fo_creadat, fo_majdate, fo_majsrc, fo_abddate, fo_abdsrc FROM vt_fibre;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_position SELECT ps_id, ps_code, ps_numero, ps_1, ps_2, ps_cs_code, ps_ti_code, ps_type, ps_fonct, ps_etat, ps_preaff, ps_comment, ps_creadat, ps_majdate, ps_majsrc, ps_abddate, ps_abdsrc FROM vt_position;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_ropt SELECT rt_id, rt_code, rt_code_ext, rt_fo_code, rt_comment, rt_creadat, rt_majdate, rt_majsrc, rt_abddate, rt_abdsrc FROM vt_ropt;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_siteemission SELECT se_id, se_nd_code, se_anfr, se_prop, se_gest, se_user, se_proptyp, se_statut, se_etat, se_occp, se_dateins, se_datemes, se_type, se_haut, se_ad_code, se_creadat, se_majdate, se_majsrc, se_abddate, se_abdsrc FROM vt_siteemission;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_znro SELECT zn_id, zn_code, zn_nd_code, zn_r1_code, zn_r2_code, zn_r3_code, zn_r4_code, zn_nroref, zn_nrotype, zn_etat, zn_etatlpm, zn_datelpm, zn_comment, zn_geolsrc, zn_creadat, zn_majdate, zn_majsrc, zn_abddate, zn_abdsrc, Geometry FROM vt_znro;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_zsro SELECT zs_id, zs_code, zs_nd_code, zs_r1_code, zs_r2_code, zs_r3_code, zs_r4_code, zs_refpm, zs_etatpm, zs_dateins, zs_typeemp, zs_capamax, zs_ad_code, zs_typeing, zs_nblogmt, zs_nbcolmt, zs_datcomr, zs_actif, zs_datemad, zs_accgest, zs_comment, zs_geolsrc, zs_creadat, zs_majdate, zs_majsrc, zs_abddate, zs_abdsrc, Geometry FROM vt_zsro;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_zpbo SELECT zp_id, zp_code, zp_nd_code, zp_zs_code, zp_r1_code, zp_r2_code, zp_r3_code, zp_r4_code, zp_comment, zp_geolsrc, zp_creadat, zp_majdate, zp_majsrc, zp_abddate, zp_abdsrc, Geometry FROM vt_zpbo;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_zdep SELECT zd_id, zd_code, zd_nd_code, zd_zs_code, zd_r1_code, zd_r2_code, zd_r3_code, zd_r4_code, zd_prop, zd_gest, zd_statut, zd_comment, zd_geolsrc, zd_creadat, zd_majdate, zd_majsrc, zd_abddate, zd_abdsrc, Geometry FROM vt_zdep;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_zcoax SELECT zc_id, zc_code, zc_codeext, zc_nd_code, zc_r1_code, zc_r2_code, zc_r3_code, zc_r4_code, zc_prop, zc_gest, zc_statut, zc_comment, zc_geolsrc, zc_creadat, zc_majdate, zc_majsrc, zc_abddate, zc_abdsrc, Geometry FROM vt_zcoax;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_document SELECT do_id, do_ref, do_reftier, do_type, do_indice, do_date, do_classe, do_url1, do_url2, do_comment, do_creadat, do_majdate, do_majsrc, do_abddate, do_abdsrc FROM vt_document;"
IF EXIST "%SHPDB%%CSV%.csv" %SPLEX% %SPLDB% "INSERT INTO t_docobj SELECT od_id, od_do_ref, od_tbltype, od_codeobj, od_creadat, od_majdate, od_majsrc, od_abddate, od_abdsrc FROM vt_docobj;"
IF EXIST "%SHPDB%%SHP%.shp" %SPLEX% %SPLDB% "INSERT INTO t_empreinte SELECT em_id, em_code, em_do_ref, em_geolsrc, em_creadat, em_majdate, em_majsrc, em_abddate, em_abdsrc, Geometry FROM vt_empreinte;" 

GOTO:EOF

PAUSE
