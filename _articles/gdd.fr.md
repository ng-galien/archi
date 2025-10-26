lang: fr
page_id: article-gdd
title: Des Tables Obèses aux Relations Fonctionnelles
description: Article de fond sur le Graph-Driven Design et le déplacement de la variabilité vers les relations.
permalink: /articles/gdd/
nav_section: articles
weight: 10
---

# Des Tables Obèses aux Relations Fonctionnelles : Pour une Modélisation de Données Plus Naturelle et Évolutive

<div class="language-switch">[English]({{ '/articles/gdd/' | relative_url }}) | Français</div>

{% comment %} Contenu migré depuis fr/gdd/index.md {% endcomment %}

## Introduction

Dans le monde de l'ingénierie logicielle, la modélisation de données est au cœur de tout système d'information. Pourtant, au fil des évolutions et des besoins métier changeants, de nombreux systèmes finissent par accumuler une complexité inutile, menant à des structures rigides et difficiles à maintenir. Ce papier vise à explorer un problème récurrent – l'"obésité des tables" dans les bases de données relationnelles – et à proposer une alternative inspirée des graphes, enrichie d'une perspective fonctionnelle. En nous basant sur une analyse terrain, nous développerons les points clés pour montrer comment déplacer la variabilité vers les relations et les transformations pures peut rendre les modèles plus alignés avec le métier, plus lisibles et plus robustes.

Cette approche ne vise pas à rejeter les bases relationnelles traditionnelles, mais à les compléter par une pensée plus fluide, adaptée aux réalités des équipes de développement. Nous aborderons d'abord le diagnostic du problème, puis l'alternative graphique, et enfin une extension fonctionnelle qui transforme le métier en un flux de relations immutables. Des exemples concrets et des implications pratiques seront développés pour illustrer chaque point.

## Le Constat du Terrain : Un Réflexe Data-First Dominant

Sur le terrain, les équipes de développement abordent souvent les problèmes métier à travers le prisme des données concrètes plutôt que des concepts abstraits. Lorsqu'un nouveau besoin émerge – par exemple, ajouter une fonctionnalité de promotion sur un produit dans un système e-commerce –, la première question posée n'est pas "Quel est le concept métier sous-jacent ?" mais plutôt "Qu'est-ce qu'on ajoute comme colonnes dans la table Product ?". Ce réflexe est humainement rassurant : il offre un point de départ tangible, ancré dans l'existant, et permet de prototyper rapidement.

Cependant, ce biais "data-first" a des conséquences à long terme. À force de raisonner en termes de structures statiques, la logique métier se subordonne à la base de données. Les tables deviennent des archives vivantes de compromis historiques : un champ ajouté pour une exception temporaire, un statut pour une variante saisonnière, un indicateur booléen pour un cas particulier. Au fil des itérations, cela crée une dette technique invisible, où la structure domine la sémantique. Dans des projets réels, comme des CRM ou des ERP, j'ai observé que cela mène à une fragmentation cognitive : les développeurs passent plus de temps à naviguer dans des schémas complexes qu'à implémenter de la valeur métier.

Pour développer ce point, considérons un exemple concret. Imaginons une table Customer dans un système de gestion clients. Au départ, elle contient des champs basiques : id, name, email. Puis, avec l'ajout de fonctionnalités comme les abonnements, les préférences marketing ou les adresses multiples, on ajoute des colonnes nullable (subscription_end_date, marketing_opt_in) ou des JSON blobs pour la flexibilité. Résultat : la table gonfle, et le code associé (queries SQL, ORM mappings) devient un labyrinthe de conditions pour gérer les nulls et les incohérences.

## L'Obésité des Tables : Symptômes et Conséquences

Dans presque tous les systèmes matures, on retrouve des "géants" comme les tables Product, Customer ou Order. Ces entités commencent simples, avec une dizaine de colonnes essentielles. Mais au fil des années, elles accumulent de la "graisse" : plus de 100 colonnes, dont la moitié nullable, pour accommoder chaque nouvelle exigence sans refondre le modèle.

Les signes d'obésité sont clairs :
- **Nullabilité excessive** : Des champs optionnels partout, forçant le code à être truffé de garde-fous (if not null). Cela augmente les risques d'erreurs runtime et complique les tests.
- **Colonnes contradictoires** : Plusieurs façons d'exprimer la même idée, comme un statut "active" et un flag "is_deleted", menant à des incohérences logiques.
- **Objets massifs** : Les entités deviennent des "sacs à champs" optionnels, rendant les objets métier (DTOs, entities) lourds et peu expressifs.
- **Fragilité globale** : Toute évolution – ajouter un champ – menace des comportements existants, car les dépendances sont cachées dans le code legacy.

Les conséquences sont multiples. D'un point de vue technique, cela dégrade les performances (indexes surabondants, scans inutiles) et augmente la courbe d'apprentissage pour les nouveaux arrivants. Sur le plan métier, la table ne reflète plus la réalité dynamique du business, mais une sédimentation de correctifs. Par exemple, dans un système de commande en ligne, la table Order pourrait accumuler des colonnes comme promo_code (nullable), discount_amount (dérivé mais stocké), leading à des redondances et des bugs lors des mises à jour.

Ce phénomène n'est pas inévitable ; il découle d'une modélisation qui force la variabilité à s'exprimer au sein des entités plutôt que dans leurs interactions.

## Les Limites des Modèles Conceptuels Traditionnels

Des approches comme le Domain-Driven Design (DDD) ou l'architecture hexagonale tentent de recentrer le métier en modélisant des agrégats, des entités et des value objects autour des concepts business. Elles encouragent une séparation claire entre la logique métier et la persistance, avec des repositories abstraits.

Cependant, ces méthodes exigent une culture d'équipe mature : ateliers de modélisation, discipline dans les bounded contexts, et une tolérance à l'abstraction. Dans la réalité de nombreuses équipes – contraintes par des deadlines, des devs juniors ou un legacy imposant –, la pensée data-first persiste car elle est plus intuitive et immédiate. Plutôt que de combattre ce réflexe, il est plus pragmatique de l'adapter en offrant un cadre plus souple, qui part des données mais les rend évolutives.

## L'Alternative : Penser en Graphe pour Déplacer la Variabilité

Les bases de données graphiques (comme Neo4j) offrent une solution élégante en traitant les relations comme des éléments premiers, au même titre que les entités. Au lieu de gonfler les tables, on maintient des nœuds simples (Product, Customer, Order) et on exprime la variabilité via des liens : HAS_PRICE (avec attributs comme amount, currency), PLACED_BY (avec date, channel), HAS_STATUS (avec value, timestamp).

Développement clé : L'absence d'un lien remplace naturellement la valeur nulle. Pas de HAS_PROMO ? Pas de promotion active. Cela élimine les nulls inutiles et rend le modèle cohérent. Chaque relation peut porter ses propres métadonnées (date de validité, contexte), permettant une modélisation fine sans muter les entités centrales.

Les effets concrets sont transformateurs :
- **Lisibilité accrue** : Le graphe décrit le métier par sa structure interconnectée, pas par une accumulation de champs.
- **Évolution simplifiée** : Ajouter un lien (e.g., HAS_RECOMMENDATION) ne casse rien ; c'est une extension non intrusive.
- **Code plus clair** : Des objets métiers petits, non-nullables, facilitant les patterns comme les builders ou les immutables.
- **Discussions métier** : Les équipes parlent en termes de relations ("Comment lier ce produit à ce client ?"), alignant mieux avec le langage business.

Exemple développé : Dans un système de e-commerce, au lieu d'une table Product avec 50 colonnes, on a un nœud Product lié à PRICE (valide pour une période), à CATEGORY, à SUPPLIER. Une requête pour un prix promo devient une traversal de graphe : Product -> HAS_PROMO -> DISCOUNTED_PRICE, avec des filtres sur les attributs des liens.

Ce changement de perspective ne supprime pas la complexité, mais la rend maniable : les liens peuvent être datés, versionnés, contextualisés, racontant les interactions sans fusionner les entités. Le modèle évolue par extension, non par mutation destructive.

## Extension Fonctionnelle : Le Métier comme Transformation de Relations

Pour aller plus loin, considérons le métier non comme un état statique, mais comme un flux de transformations sur ces relations. La plupart des règles business se ramènent à : prendre un ensemble de relations existantes et en dériver de nouvelles.

Développement : Un calcul de prix transforme les liens (Product -> CHANNEL -> PERIOD) en une nouvelle relation HAS_EFFECTIVE_PRICE. Une validation de commande dérive LIVRABLE à partir de (Order -> ITEMS -> STOCK). Cela s'aligne avec le paradigme fonctionnel : fonctions pures (sans effets de bord), immutables, qui prennent des inputs relationnels et produisent des outputs sans altérer l'existant.

Les relations existantes racontent le passé ; les nouvelles décrivent le présent. Un parcours métier devient une composition : [relations₀] → fonction1 → [relations₁] → fonction2 → [relations₂]. La persistance n'est qu'une synchronisation : accumuler les faits (append-only), sans écraser l'historique.

## Voir aussi

- Comparatif : [DDD vs GDD]({{ '/articles/ddd-vs-gdd/' | relative_url }})
