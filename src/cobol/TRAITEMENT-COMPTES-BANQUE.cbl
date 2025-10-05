       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRAITEMENT-COMPTES-BANQUE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FICHIER-ENTREE ASSIGN TO 'COMPTES-IN.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT FICHIER-SORTIE ASSIGN TO 'COMPTES-OUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD FICHIER-ENTREE.
            01 ENREGISTREMENT-ENTREE.
                COPY '../copybooks/COMPTE-ENTREE.cpy'.

       FD FICHIER-SORTIE.
           01 ENREGISTREMENT-SORTIE.
               COPY '../copybooks/COMPTE-SORTIE.cpy'.

       WORKING-STORAGE SECTION.
           COPY 'CONSTANTES.cpy'.

       PROCEDURE DIVISION.
       MAIN-SECTION.
           DISPLAY "========================================".
           DISPLAY "  TRAITEMENT DES COMPTES BANCAIRES ".
           DISPLAY "========================================".

           OPEN INPUT FICHIER-ENTREE
                OUTPUT FICHIER-SORTIE.

           PERFORM JUSQUA-FIN-FICHIER
               UNTIL WS-EOF = 'O'.

           CLOSE FICHIER-ENTREE FICHIER-SORTIE.
           DISPLAY "Traitement terminé.".
           STOP RUN.

       JUSQUA-FIN-FICHIER.
           READ FICHIER-ENTREE
               AT END
                   MOVE 'O' TO WS-EOF
               NOT AT END
                   PERFORM CALCULS-COMPTE
           END-READ.

       CALCULS-COMPTE.
           COMPUTE WS-INTERET = ENREGISTREMENT-ENTREE.SOLDE-COMPTE
                               * ENREGISTREMENT-ENTREE.TAUX-INTERET

           IF ENREGISTREMENT-ENTREE.TYPE-COMPTE = 'C'
               MOVE WS-FRAIS-COMPTE-C TO WS-FRAIS
           ELSE
               MOVE WS-FRAIS-COMPTE-E TO WS-FRAIS
           END-IF

           COMPUTE WS-NOUVEAU-SOLDE = ENREGISTREMENT-ENTREE.SOLDE-COMPTE
                                       + WS-INTERET - WS-FRAIS

           MOVE ENREGISTREMENT-ENTREE.NUM-COMPTE         TO ENREGISTREMENT-SORTIE.NUM-COMPTE-S
           MOVE WS-NOUVEAU-SOLDE                          TO ENREGISTREMENT-SORTIE.NOUVEAU-SOLDE-S
           MOVE WS-INTERET                                TO ENREGISTREMENT-SORTIE.INTERET-CALCULE-S
           MOVE WS-FRAIS                                  TO ENREGISTREMENT-SORTIE.FRAIS-APPLIQUES-S

           WRITE ENREGISTREMENT-SORTIE

           DISPLAY "Compte traité : " ENREGISTREMENT-ENTREE.NUM-COMPTE
                   " | Solde init. : " ENREGISTREMENT-ENTREE.SOLDE-COMPTE
                   " | Intérêt : " WS-INTERET
                   " | Frais : " WS-FRAIS
                   " | Nouveau solde : " WS-NOUVEAU-SOLDE.

