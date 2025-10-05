       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRAITEMENT-COMPTES-BANQUE.
       AUTHOR. CHATGPT.

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
           05 NUM-COMPTE         PIC X(10).
           05 SOLDE-COMPTE       PIC 9(7)V99.
           05 TAUX-INTERET       PIC 9V999.
           05 TYPE-COMPTE        PIC X(01).   *> 'C' = courant, 'E' = épargne

       FD FICHIER-SORTIE.
       01 ENREGISTREMENT-SORTIE.
           05 NUM-COMPTE-S       PIC X(10).
           05 NOUVEAU-SOLDE-S    PIC 9(7)V99.
           05 INTERET-CALCULE-S  PIC 9(7)V99.
           05 FRAIS-APPLIQUES-S  PIC 9(5)V99.

       WORKING-STORAGE SECTION.
       01 WS-EOF                 PIC X VALUE 'N'.
       01 WS-INTERET             PIC 9(7)V99 VALUE 0.
       01 WS-FRAIS               PIC 9(5)V99 VALUE 0.
       01 WS-NOUVEAU-SOLDE       PIC 9(7)V99 VALUE 0.

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
           COMPUTE WS-INTERET = SOLDE-COMPTE * TAUX-INTERET.

           IF TYPE-COMPTE = 'C'
               MOVE 5.00 TO WS-FRAIS
           ELSE
               MOVE 0 TO WS-FRAIS
           END-IF.

           COMPUTE WS-NOUVEAU-SOLDE = SOLDE-COMPTE + WS-INTERET - WS-FRAIS.

           MOVE NUM-COMPTE         TO NUM-COMPTE-S.
           MOVE WS-NOUVEAU-SOLDE   TO NOUVEAU-SOLDE-S.
           MOVE WS-INTERET         TO INTERET-CALCULE-S.
           MOVE WS-FRAIS           TO FRAIS-APPLIQUES-S.

           WRITE ENREGISTREMENT-SORTIE.

           DISPLAY "Compte traité : " NUM-COMPTE
                   " | Solde init. : " SOLDE-COMPTE
                   " | Intérêt : " WS-INTERET
                   " | Frais : " WS-FRAIS
                   " | Nouveau solde : " WS-NOUVEAU-SOLDE.
