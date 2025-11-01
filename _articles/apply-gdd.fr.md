---
lang: fr
page_id: apply-product-gdd
title: Du Produit Monolithique au Produit Relationnel (GDD)
description: Cas décisif — comparer une modélisation monolithique centrée sur Product avec une approche Graph-Driven orientée relations, multi-domaines.
permalink: /articles/apply-product-gdd/
nav_section: articles
weight: 12
---

# Du Produit Monolithique au Produit Relationnel

> Objectif : montrer comment la transformation du “produit” — entité centrale mais obèse — en réseau de relations vivantes rend le système plus expressif, plus explicable et plus évolutif.

---

## 1) Le Produit devenu obèse

Dans la plupart des systèmes d’information (retail, e‑commerce, B2B), **Product** est le point de passage obligé : tout y converge — **prix**, **stock**, **livraison**, **facturation**, **approvisionnement**.  
Avec le temps, ce pivot est devenu un poids.  

Chaque domaine, cherchant à y inscrire sa part de vérité, a ajouté son attribut :  
une colonne pour la promo, une pour la devise, une autre pour la zone de livraison…  
Jusqu’à ce que la table devienne un palimpseste où cohabitent des règles contradictoires.

```sql
PRODUCT(
  id,
  sku,
  name,
  description,
  category_id,
  supplier_id,
  list_price,
  discount,
  currency,
  weight_kg,
  length_cm, width_cm, height_cm,
  shipping_mode,
  stock_qty,
  warehouse_id,
  tax_category,
  is_active,
  created_at, updated_at
);
```

Au début, c’était simple : un seul objet, une seule table, tout semblait à portée de main.  
Mais peu à peu, les symptômes sont apparus :

- **Couplage transversal** : le produit devient le centre de gravité de tous les domaines.  
- **Nullabilité chronique** : une colonne par cas, et la moitié d’entre elles vides.  
- **Intégrations fragiles** : chaque domaine lit et écrit sa propre vérité dans le même espace.  

L’entité *Product* a cessé d’être un modèle : elle est devenue un compromis.

---

## 2) Le symptôme : la promo introuvable

Une équipe marketing veut lancer une promotion sur le canal web pour une zone spécifique.  
Problème : dans le modèle actuel, cette notion n’existe pas vraiment.  
Il faut bricoler : ajouter une colonne `discount_web`, une table de “règles de promo”, un flag `active`.  
Les développeurs se demandent : *“Et si une autre promo s’applique au même moment ?”*  
Le code multiplie les `if`, les scripts de migration s’empilent, les anomalies s’accumulent.

La même scène se reproduit pour le **stock**, pour le **shipping**, pour le **prix**.  
Chaque évolution du métier devient une nouvelle couche de complexité.

> Le modèle ne raconte plus l’histoire du produit : il l’enterre sous des colonnes.

---

## 3) Point de bascule : déplacer la variabilité vers les relations

Et si le produit cessait d’être un objet figé pour devenir un **nœud d’identités stables** autour duquel gravitent les faits métier ?  
Au lieu d’ajouter des champs, on **crée des liens**.  
Chaque lien exprime une vérité : un prix, une promo, un stock, une provenance.  
L’absence de lien devient elle aussi signifiante.

```text
[Product]
 ├─[pricing.HAS_PRICE {currency, amount, channel, valid_from,to}]
 ├─[pricing.HAS_PROMO {kind, value, segment, valid_from,to}]
 ├─[inventory.HAS_STOCK_LEVEL {warehouse, qty, ts}]
 ├─[shipping.SHIPPED_AS {mode, region, cost, valid_from,to}]
 └─[supply.PROCURED_FROM {supplier_code, lead_time_days}]
```

Ce changement paraît simple, mais il renverse tout :  
on ne **met plus à jour** un produit, on **ajoute un fait**.  
On ne stocke plus un état, on décrit une **transition**.

La donnée cesse d’être un objet ; elle devient un **flux de relations vivantes**.
