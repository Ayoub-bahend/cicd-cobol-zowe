# Gestion des Comptes Bancaires sur Mainframe

## Objectif du Projet

Ce projet a pour objectif de démontrer un processus complet de gestion des comptes bancaires sur un environnement mainframe. Il inclut le développement, le déploiement, l'exécution et la surveillance d'un programme COBOL qui traite des données de comptes bancaires. Le pipeline CI/CD est automatisé pour garantir un déploiement fluide et une exécution fiable.

Le programme COBOL, `TRAITEMENT-COMPTES-BANQUE`, calcule les intérêts, applique des frais, et met à jour les soldes des comptes bancaires en fonction des données d'entrée.

---

## Structure du Projet

### 1. **Fichiers COBOL et Copybooks**
- **[`src/cobol/TRAITEMENT-COMPTES-BANQUE.cbl`](src/cobol/TRAITEMENT-COMPTES-BANQUE.cbl)**  
  Programme principal qui traite les comptes bancaires. Il lit les données d'entrée, effectue des calculs (intérêts, frais) et écrit les résultats dans un fichier de sortie.

- **[`src/copybooks/ENTR.cpy`](src/copybooks/ENTR.cpy)**  
  Définit la structure des enregistrements de comptes d'entrée.

- **[`src/copybooks/SORT.cpy`](src/copybooks/SORT.cpy)**  
  Définit la structure des enregistrements de comptes de sortie.

- **[`src/copybooks/CST.cpy`](src/copybooks/CST.cpy)**  
  Contient les constantes et variables globales utilisées dans le programme COBOL.

---

### 2. **Fichiers JCL**
- **[`src/jcl/compile_TRAITEMENT.jcl`](src/jcl/compile_TRAITEMENT.jcl)**  
  Script JCL pour compiler le programme COBOL sur le mainframe.

- **[`src/jcl/run_TRAITEMENT.jcl`](src/jcl/run_TRAITEMENT.jcl)**  
  Script JCL pour exécuter le programme COBOL sur le mainframe.

---

### 3. **Scripts**
- **[`src/scripts/deploy.sh`](src/scripts/deploy.sh)**  
  Script Bash pour automatiser le déploiement des fichiers COBOL, copybooks et JCL sur le mainframe. Il soumet également les jobs de compilation et d'exécution.

- **[`src/scripts/monitor.py`](src/scripts/monitor.py)**  
  Script Python pour surveiller les sorties JES des jobs soumis. Il détecte les erreurs (`ERROR` ou `ABEND`) dans les logs.

- **[`src/scripts/config.json`](src/scripts/config.json)**  
  Fichier de configuration contenant les informations de connexion au mainframe (profil Zowe, chemins distants, etc.).

---

### 4. **Ansible**
- **[`src/ansible/inventory.yml`](src/ansible/inventory.yml)**  
  Définit les hôtes cibles pour les tâches Ansible (ex. : mainframe sandbox).

- **[`src/ansible/playbook_deploy.yml`](src/ansible/playbook_deploy.yml)**  
  Playbook Ansible principal pour déployer le programme COBOL et exécuter les jobs JCL.

- **[`src/ansible/roles/mainframe/tasks/deploy.yml`](src/ansible/roles/mainframe/tasks/deploy.yml)**  
  Tâches Ansible pour uploader les fichiers COBOL et JCL sur le mainframe.

- **[`src/ansible/roles/mainframe/tasks/monitor.yml`](src/ansible/roles/mainframe/tasks/monitor.yml)**  
  Tâches Ansible pour soumettre et surveiller les jobs JCL.

- **[`src/ansible/roles/mainframe/vars/mainframe_vars.yml`](src/ansible/roles/mainframe/vars/mainframe_vars.yml)**  
  Variables utilisées dans les tâches Ansible (profil Zowe, chemins distants, etc.).

---

### 5. **Workflows GitHub Actions**
- **[`.github/workflows/pipeline.yml`](.github/workflows/pipeline.yml)**  
  Pipeline CI/CD pour compiler et exécuter le programme COBOL localement avec GnuCOBOL.

- **[`.github/workflows/mainframe.yml`](.github/workflows/mainframe.yml)**  
  Pipeline CI/CD pour déployer et exécuter le programme COBOL sur le mainframe.

- **[`.github/workflows/supervisor.yml`](.github/workflows/supervisor.yml)**  
  Orchestrateur pour déclencher les workflows `pipeline.yml` et `mainframe.yml`.

---

## Fonctionnement Global

1. **Compilation et Exécution Locale**  
   Le workflow `pipeline.yml` compile et exécute le programme COBOL localement à l'aide de GnuCOBOL.

2. **Déploiement sur le Mainframe**  
   Le workflow `mainframe.yml` déploie les fichiers COBOL, copybooks et JCL sur le mainframe, puis soumet les jobs pour compilation et exécution.

3. **Surveillance des Jobs**  
   Les scripts Ansible et Python surveillent les sorties JES pour détecter les erreurs et afficher les résultats.

---

## Prérequis

- **Zowe CLI** pour interagir avec le mainframe.
- **Ansible** pour l'automatisation des tâches.
- **GnuCOBOL** pour les tests locaux.
- **GitHub Actions** pour les pipelines CI/CD.

---

## Contribution

Les contributions sont les bienvenues ! Veuillez ouvrir une issue ou soumettre une pull request pour toute amélioration ou correction.

---

## Licence

Ce projet est sous licence MIT. Consultez le fichier `LICENSE` pour plus de détails.