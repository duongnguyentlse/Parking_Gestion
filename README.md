# Parking Management 🚗🅿️

## Présentation  
Ce projet est une continuation des travaux réalisés dans les UEs **ILU1 et ILU2**. Il vise à gérer un parking avec diverses fonctionnalités, notamment **l'ajout, la suppression, la modification, le tri et la recherche de billets de stationnement**. Le projet est implémenté en **Java, OCaml et Coq**.

## Objectifs  
- Gérer un parking avec **des tickets de stationnement associés à chaque véhicule**.  
- Calculer les frais de stationnement en fonction **du type de véhicule et du temps de stationnement**.  
- Appliquer des **amendes éventuelles** selon certaines conditions.  
- Assurer **l'accessibilité aux personnes à mobilité réduite**.  

## Fonctionnalités  
- **Gestion des tickets** :  
  - Ajout, suppression, modification, tri et recherche de tickets.  
- **Système de tarification dynamique** :  
  - Les tarifs augmentent toutes les **60 minutes** selon le type de véhicule.  
- **Système d’amendes** :  
  - Les véhicules peuvent recevoir des **amendes en cas d’infraction**.  

## Modèle de Tarification  
Chaque véhicule dispose d’un **tarif initial** et d’une méthode spécifique pour calculer l’évolution du tarif toutes les **60 minutes**.  

| Type de véhicule | Tarif initial | Augmentation par heure |
|-----------------|--------------|----------------------|
| **4-roues**    | 30 €         | +30 % du tarif initial |
| **2-roues**    | 10 €         | +10 % du tarif initial |

**Formule de calcul du montant total** :  
```plaintext
Montant total = (Tarif initial + Tarif supplémentaire) + Amende éventuelle
```
## Installation et Exécution (OCaml uniquement)  

⚠️ **Ce guide d'installation et d'exécution concerne uniquement la version OCaml du projet.**  

### Prérequis  
Avant d'exécuter le programme, assurez-vous d'avoir installé **ocamlfind**, un gestionnaire de bibliothèques pour OCaml. Vous pouvez l'installer via OPAM :  

🔗 [Installation de ocamlfind](https://opam.ocaml.org/packages/ocamlfind/)  

### Lancer le programme avec une opération CRUD sur le fichier de données :  
Example avec l'opération D (Delete)
```bash
make
./crudocaml.exe -d data/data.csv
```
[Voici un exemple d'exécution en Ocaml](https://github.com/duongnguyentlse/Parking_Gestion/blob/main/ParkingManagement/ExecutionOcaml.png)



