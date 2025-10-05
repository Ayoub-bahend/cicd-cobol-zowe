# Projet CI/CD COBOL avec Zowe CLI, Ansible & GitHub Actions

Ce projet illustre la **mise en place d’un pipeline CI/CD** utilisant Git, Ansible et GitHub Actions pour automatiser la **compilation et le déploiement d’un programme COBOL** avec intégration SQL.  
Le pipeline inclut également un **monitoring via Python** et l’**intégration de Zowe CLI** pour simuler la modernisation d’un mainframe vers un environnement ouvert.

Le programme COBOL, `TRAITEMENT-COMPTES-BANQUE`, calcule les intérêts, applique des frais, et met à jour les soldes des comptes bancaires en fonction des données d’entrée.


---

## Table des matières

1. [Objectif du Projet](#objectif-du-projet)
2. [Structure du Projet](#structure-du-projet)
3. [Prérequis](#prérequis)
4. [Configuration Locale](#configuration-locale)
5. [Test du Pipeline Localement](#test-du-pipeline-localement)
6. [CI/CD avec GitHub Actions](#cicd-avec-github-actions)
7. [Ansible Playbook](#ansible-playbook)
8. [Sécurité et GitHub Secrets](#sécurité-et-github-secrets)
9. [Sources](#sources)
10. [Licence](#licence)

---

## Objectif du projet

L'objectif de ce projet est de mettre en place un pipeline CI/CD complet pour automatiser le **développement, la compilation, le déploiement et le monitoring** d’un programme COBOL sur un environnement mainframe simulé.  
Le projet illustre la modernisation d’un mainframe vers un environnement ouvert grâce à l’intégration de **Zowe CLI**, tout en garantissant une exécution fiable et traçable des traitements bancaires.

---

## Structure du Projet
```
├── .github
│   └── workflows
│       ├── mainframe.yml
│       └── pipeline.yml
├── .gitignore
├── Readme.md
└── src
    ├── ansible
    │   ├── inventory.yml
    │   ├── playbook_deploy.yml
    │   └── roles
    │       └── mainframe
    │           ├── tasks
    │           │   ├── deploy.yml
    │           │   └── monitor.yml
    │           └── vars
    │               └── mainframe_vars.yml
    ├── cobol
    │   └── TRAITEMENT-COMPTES-BANQUE.cbl
    ├── copybooks
    │   ├── CST.cpy
    │   ├── ENTR.cpy
    │   └── SORT.cpy
    ├── data
    │   └── COMPTES-IN.DAT
    ├── jcl
    │   ├── compile_TRAITEMENT.jcl
    │   └── run_TRAITEMENT.jcl
    └── scripts
        ├── config.json
        ├── deploy.sh
        └── monitor.py
```        


---

## Prérequis

- **Zowe CLI** pour interagir avec le mainframe.
- **Ansible** pour l'automatisation des tâches.
- **GnuCOBOL** pour les tests locaux.
- **GitHub Actions** pour les pipelines CI/CD.
- **Docker** (optionnel pour Zowe Sandbox).

---

## Configuration Locale

1. Installer **Zowe CLI** :

```bash
npm install -g @zowe/cli
```

---

## Créer un profil pour Zowe Sandbox (ou mainframe réel si disponible) :

```bash
zowe profiles create zosmf-profile mainframe-sandbox \
  --host localhost \
  --port 1443 \
  --user demo \
  --password demo123 \
  --reject-unauthorized false
```

---

## Créer un fichier config.json local pour les tests (ajouter à .gitignore) :

```json
{
  "zosmf_profile": "mainframe-sandbox",
  "host": "localhost",
  "port": 1443,
  "user": "demo",
  "password": "demo123",
  "remote_cobol_path": "/u/USER/COBOL",
  "remote_jcl_path": "/u/USER/JCL"
}
```

---

## Test du Pipeline Localement
### Compiler et exécuter COBOL localement :

```bash
cd src/cobol
cobc -x -o TRAITEMENT-COMPTES-BANQUE TRAITEMENT-COMPTES-BANQUE.cbl -I ../copybooks
./TRAITEMENT-COMPTES-BANQUE
```

Vérifier les résultats dans src/data/COMPTES-OUT.DAT.

---

## CI/CD avec GitHub Actions

### Workflows

- **pipeline.yml** : Compile et exécute COBOL localement.
- **mainframe.yml** : Déploie les fichiers COBOL et JCL sur le mainframe via Zowe CLI et Ansible.

### Exemple GitHub Actions

```yaml
- name: Install Ansible
  run: sudo apt-get install -y ansible

- name: Run Ansible Playbook
  run: ansible-playbook ansible/playbook_deploy.yml -i ansible/inventory.yml
```
---

## Ansible Playbook

### Fonctionnalités

1. **Déploiement des fichiers COBOL et JCL**  
   - Tâches définies dans `roles/mainframe/tasks/deploy.yml`.

2. **Soumission et Monitoring des Jobs JCL**  
   - Tâches définies dans `roles/mainframe/tasks/monitor.yml`.

### Configuration

- Les variables sont définies dans `roles/mainframe/vars/mainframe_vars.yml`.

---

## Sécurité et GitHub Secrets

- Ne jamais mettre **identifiants réels** dans le repo.
- Stocker les informations sensibles comme secrets GitHub :
  - `ZOS_HOST`
  - `ZOS_USER`
  - `ZOS_PASS`

### Exemple d’utilisation dans `mainframe.yml` :

```yaml
zowe profiles create zosmf-profile mainframe-prof \
  --host ${{ secrets.ZOS_HOST }} \
  --port 443 \
  --user ${{ secrets.ZOS_USER }} \
  --password ${{ secrets.ZOS_PASS }} \
  --reject-unauthorized false
```
---
## Sources

Voici les principales ressources utilisées pour construire ce projet :

### Documentation COBOL

- [IBM COBOL for Enterprise Developers](https://www.ibm.com/docs/en/cobol)  
- [GnuCOBOL User Guide](https://gnucobol.sourceforge.io)

### Zowe CLI

- [Zowe CLI Documentation](https://docs.zowe.org)

### Ansible

- [Ansible Documentation](https://docs.ansible.com)

### JCL

- [IBM JCL Reference Guide](https://www.ibm.com/docs/en/zos)

### GitHub Actions

- [GitHub Actions Documentation](https://docs.github.com/actions)

### Tutoriels et Blogs

- [COBOL Tutorials on TutorialsPoint](https://www.tutorialspoint.com/cobol)  
- [Mainframe DevOps Blog](https://developer.ibm.com/devops/mainframe)

---

## Licence

Ce projet est sous licence MIT. Consultez le fichier `LICENSE` pour plus de détails.