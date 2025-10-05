       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRAITEMENT-COMPTES-BANQUE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FICHIER-ENTREE ASSIGN TO 'src/data/COMPTES-IN.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT FICHIER-SORTIE ASSIGN TO 'src/data/COMPTES-OUT.DAT'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD FICHIER-ENTREE.
           COPY '../copybooks/ENTR.cpy'.

       FD FICHIER-SORTIE.
           COPY '../copybooks/SORT.cpy'.

       WORKING-STORAGE SECTION.
           COPY '../copybooks/CST.cpy'.

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
           COMPUTE WS-INTERET = SOLDE-COMPTE * TAUX-INTERET

           IF TYPE-COMPTE = 'C'
               MOVE WS-FRAIS-COMPTE-C TO WS-FRAIS
           ELSE
               MOVE WS-FRAIS-COMPTE-E TO WS-FRAIS
           END-IF

           COMPUTE WS-NOUVEAU-SOLDE = SOLDE-COMPTE
                                       + WS-INTERET - WS-FRAIS

           MOVE NUM-COMPTE         TO NUM-COMPTE-S
           MOVE WS-NOUVEAU-SOLDE   TO NOUVEAU-SOLDE-S
           MOVE WS-INTERET         TO INTERET-CALCULE-S
           MOVE WS-FRAIS           TO FRAIS-APPLIQUES-S

           WRITE ENREGISTREMENT-SORTIE

           DISPLAY "Compte traité : " NUM-COMPTE
                   " | Solde init. : " SOLDE-COMPTE
                   " | Intérêt : " WS-INTERET
                   " | Frais : " WS-FRAIS
                   " | Nouveau solde : " WS-NOUVEAU-SOLDE.
