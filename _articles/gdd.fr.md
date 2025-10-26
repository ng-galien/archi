---
lang: fr
page_id: article-gdd
title: Des Tables Obèses aux Relations Fonctionnelles
description: Réflexion sur le Graph-Driven Design et la modélisation de données par relations.
permalink: /articles/gdd/
nav_section: articles
weight: 10
---

# Des Tables Obèses aux Relations Fonctionnelles : Pour une Modélisation de Données Plus Naturelle et Évolutive

## Introduction

Dans le monde de l'ingénierie logicielle, la modélisation de données est au cœur de tout système d'information. Pourtant, au fil des évolutions et des besoins métier changeants, de nombreux systèmes finissent par accumuler une complexité inutile, menant à des structures rigides et difficiles à maintenir. Cet article explore un problème récurrent – l’« obésité des tables » dans les bases relationnelles – et propose une alternative inspirée des graphes et du paradigme fonctionnel.  

L’objectif n’est pas de rejeter les bases relationnelles, mais de montrer comment le fait de déplacer la variabilité vers les **relations** peut rendre les modèles plus naturels, plus adaptatifs, et plus fidèles à la réalité métier.  

Nous aborderons successivement :
- le constat terrain du biais *data-first*,
- les symptômes de l’obésité des tables,
- les limites du modèle orienté objet et du DDD classique,
- l’alternative graphique et relationnelle,
- l’extension fonctionnelle du métier comme flux de transformations,
- et enfin la compatibilité du GDD (Graph-Driven Design) avec les architectures modernes.

---

## 1. Le Constat du Terrain : Un Réflexe Data-First Dominant

Dans la majorité des équipes, lorsqu’un besoin émerge, la question réflexe est :  
> « Qu’est-ce qu’on ajoute dans la table ? »  

Ce réflexe *data-first* est intuitif : il donne un point de départ concret. Pourtant, il amène à penser les problèmes à travers la structure, non la signification.  

À long terme, cette approche crée un écart entre le métier et le modèle. Les tables deviennent des archives de compromis : un champ ajouté pour un cas temporaire, un booléen pour une exception, un JSON pour un besoin pressant.  
Le résultat est une structure figée, où chaque ajout complexifie le système existant au lieu de le clarifier.

### Conséquence organisationnelle

Les équipes passent plus de temps à gérer des schémas qu’à raisonner sur le métier.  
Chaque changement devient une opération lourde : migration, tests, refactorings d’ORM.  
Cette dette structurelle devient un frein à la souplesse, un paradoxe pour un système censé refléter la réalité mouvante d’une entreprise.

---

## 2. L’Obésité des Tables : Symptômes et Conséquences

Dans la plupart des systèmes matures, certaines tables deviennent monstrueuses : **Product**, **Customer**, **Order**.  
Elles débutent simples, puis gonflent avec le temps, jusqu’à accumuler des centaines de colonnes, souvent à moitié nulles.

### Symptômes typiques

- **Nullabilité excessive** : des champs optionnels partout, synonymes d’incertitude.  
- **Colonnes contradictoires** : `is_deleted` et `active`, coexistant sans règle claire.  
- **Objets massifs** : entités devenant des sacs de champs optionnels.  
- **Couplage diffus** : chaque évolution risque d’en casser d’autres.

### Répercussions sur le code

Le code s’alourdit à mesure que le modèle se déforme : conditions `if not null` omniprésentes, ORM surchargés, DTOs volumineux.  
La maintenance devient un travail d’archéologie. Les nouveaux développeurs mettent des semaines à comprendre les relations cachées entre colonnes et statuts.

---

## 3. Les Limites du DDD Classique

Le **Domain-Driven Design (DDD)** a apporté un cadre précieux : recentrer le métier, isoler les invariants, parler un langage commun.  
Mais il suppose une certaine stabilité du domaine et une maturité d’équipe rarement réunies dans la réalité quotidienne.  

Les agrégats, censés être des frontières de cohérence, deviennent vite des mini-systèmes opaques.  
Le besoin de flexibilité pousse alors à les contourner : on rajoute des flags, des entités liées artificiellement, ou des états transitoires mal définis.

### Une tension entre idéal et pratique

Le DDD vise la rigueur, mais cette rigueur devient lourde quand le domaine évolue sans cesse.  
Le **GDD** ne cherche pas à le remplacer : il le prolonge, en déplaçant la cohérence de l’objet vers la **relation**.

---

## 4. L’Alternative : Penser en Graphe

Les bases graphiques, comme **Neo4j** ou **PGGraph**, proposent une approche où la **relation** est un élément de premier niveau, au même titre que les entités.  

Ainsi, au lieu d’une table `Product` avec 50 colonnes, on conserve un nœud `Product` simple, lié à des faits par des relations :  

```
[Product] --HAS_PRICE--> [Price]
          --HAS_PROMO--> [Promotion]
          --IN_CATEGORY--> [Category]
```

### Le “non-lien” comme sémantique

L’absence d’un lien devient une information : *pas de promo active*, *pas de prix défini pour ce canal*.  
Cette sémantique explicite élimine la notion de `NULL` et rend la lecture métier plus directe.

### Lecture naturelle

Le graphe reflète la pensée humaine : on explore les relations, on contextualise les faits.  
Une requête métier devient un parcours logique :  
> “Quels produits ont une promotion active dans la catégorie ‘été’ et un prix inférieur à 50 € ?”

---

## 5. Extension Fonctionnelle : Le Métier comme Flux de Relations

En s’inspirant du paradigme fonctionnel, on peut voir le métier comme une **transformation de relations**.  
Chaque règle devient une fonction pure qui prend un ensemble de liens en entrée et en produit d’autres en sortie.

```
[relations₀] → fonction1 → [relations₁] → fonction2 → [relations₂]
```

Exemples :
- Le calcul d’un **prix effectif** combine `HAS_PRICE` et `HAS_PROMO`.
- La validation d’une commande dérive `IS_DELIVERABLE` à partir de `HAS_STOCK` et `HAS_ADDRESS`.

### Propriétés clés
- **Immutabilité** : on n’écrase pas l’état précédent, on ajoute un nouveau lien.  
- **Traçabilité** : chaque transformation devient un fait historisé.  
- **Testabilité** : une fonction métier devient testable isolément, car elle ne dépend que de ses entrées.

---

## 6. Versionnement et Compatibilité

L’un des atouts majeurs du GDD est la **version des relations**.  
Chaque lien peut exister en plusieurs versions (`HAS_PRICE@v1`, `HAS_PRICE@v2`), représentant une évolution du métier sans rupture.

### Avantages

- **Rollback immédiat** : revenir à une version précédente sans migration de données.  
- **Canarisation** : plusieurs versions coexistent pour validation progressive.  
- **Évolution continue** : le modèle grandit sans effacer l’historique.

Cette approche rend possible une forme d’**agilité structurelle**, où l’évolution du métier se fait par addition, non par destruction.

---

## 7. Cohabitation avec le DDD

Le **DDD** et le **GDD** ne s’opposent pas : ils répondent à deux moments différents du cycle de conception.

| Aspect | DDD | GDD |
|--------|-----|-----|
| Unité de modélisation | Agrégat / entité | Relation |
| Cohérence | Encapsulation | Structure et invariants globaux |
| Temporalité | Optionnelle | Native |
| Évolution | Refactoring | Versionnement |
| Auditabilité | Ajoutée | Naturelle |

Le DDD structure la pensée ; le GDD structure la donnée.  
L’un encapsule, l’autre expose. Ensemble, ils offrent une vision à la fois **rigoureuse et fluide** du métier.

---

## 8. Le GDD dans un Environnement Microservices

Dans une architecture distribuée, chaque microservice gère un **sous-graphe** du système.  
Les **nœuds racines** (`Customer`, `Product`, `Order`) sont partagés, tandis que chaque service définit ses **relations spécialisées** (`pricing.*`, `fulfillment.*`, `marketing.*`).

### Bénéfices concrets

- **Découplage logique sans duplication de données**.  
- **Identité stable** : pas besoin de clés primaires inter-DB.  
- **Autonomie métier** : chaque équipe évolue son espace relationnel sans casser les autres.  
- **Cohérence systémique** : assurée par la structure et les invariants, pas par les transactions distribuées.

Le graphe devient ainsi un **socle commun** où chaque domaine ajoute sa couche sémantique.

---

## 9. Conclusion

Le **Graph-Driven Design** ne remplace pas les modèles relationnels ni le DDD, il les **étend**.  
En plaçant les relations au centre :
- il libère la variabilité,
- il capture l’histoire métier,
- et il aligne la structure technique avec le langage des faits.

Dans un monde où les domaines évoluent vite, le GDD offre une voie plus naturelle :  
celle d’un système qui raconte son propre fonctionnement à travers ses relations.

---

### Voir aussi

- [Comparatif : DDD vs GDD]({{ '/articles/ddd-vs-gdd/' | relative_url }})
