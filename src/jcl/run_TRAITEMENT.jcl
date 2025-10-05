//RUNCOB  JOB (ACCT),'RUN COBOL',
//         CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//* =======================================================
//*  EXECUTION DU PROGRAMME TRAITEMENT-COMPTES-BANQUE
//* =======================================================
//STEP1    EXEC PGM=TRAITCOMP
//STEPLIB  DD DSN=USER.COBOL.LOAD,DISP=SHR
//SYSOUT   DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//* --- Données d'entrée/sortie ---
//FICHIER-ENTREE DD DSN=USER.COBOL.DATA(COMPTESIN),DISP=SHR
//FICHIER-SORTIE DD DSN=USER.COBOL.DATA(COMPTESOUT),
//                DISP=OLD
//* =======================================================
