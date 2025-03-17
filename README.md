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
# CRUD OCaml - Guide d'Installation et d'Exécution

⚠️ **Ce guide est destiné uniquement à la version OCaml du projet.**

## 🛠️ Prérequis

Avant d'exécuter le programme, assurez-vous que les éléments suivants sont installés sur votre système :

- **OCaml** (version compatible avec votre projet)
- **OPAM** (gestionnaire de paquets OCaml)
- **ocamlfind** (gestionnaire de bibliothèques pour OCaml)

### 📥 Installation de `ocamlfind`

Si `ocamlfind` n'est pas encore installé, vous pouvez l'ajouter via OPAM en exécutant la commande suivante :

```sh
opam install ocamlfind

