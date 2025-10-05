      *****************************************************************
      * COPYBOOK : COMPTE-STRUCT.cpy
      * Description : Définitions des enregistrements de compte
      *****************************************************************

       01 ENREGISTREMENT-ENTREE.
           05 NUM-COMPTE         PIC X(10).
           05 SOLDE-COMPTE       PIC 9(7)V99.
           05 TAUX-INTERET       PIC 9V999.
           05 TYPE-COMPTE        PIC X(01).   *> 'C' = courant, 'E' = épargne

       01 ENREGISTREMENT-SORTIE.
           05 NUM-COMPTE-S       PIC X(10).
           05 NOUVEAU-SOLDE-S    PIC 9(7)V99.
           05 INTERET-CALCULE-S  PIC 9(7)V99.
           05 FRAIS-APPLIQUES-S  PIC 9(5)V99.
