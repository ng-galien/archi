---
lang: fr
page_id: gdd-ddd-gdd
permalink: /gdd/ddd-gdd.html
---

# 🧩 DDD vs GDD (Graph-Driven Design)

[English](../gdd/ddd-gdd.html) | Français

{% comment %} Contenu migré depuis fr/gdd/ddd-gdd.md {% endcomment %}

## Introduction

Cette section explore la relation entre le Domain-Driven Design (DDD) et le modèle que nous appelons ici GDD — Graph-Driven Design ou modèle relationnel-fonctionnel. Tous deux visent à aligner la technique et le métier, mais leur manière d’y parvenir diffère : DDD encapsule la cohérence dans les agrégats, tandis que GDD la distribue dans la structure des relations.

---

## Tableau comparatif

| Axe | **Domain-Driven Design (DDD)** | **Modèle Relationnel-Fonctionnel (GDD)** |
|------|----------------|----------------|
| **Unité de modélisation** | L’entité ou l’agrégat : un ensemble cohérent d’objets avec identité et invariants internes. | La relation : fait sémantique reliant des nœuds racines stables. L’unité de sens est le lien, pas l’objet. |
| **Source de vérité** | L’état d’un agrégat (objets et champs). On modifie l’état interne, puis on le persiste. | Les faits accumulés. On ne modifie pas un état ; on ajoute ou remplace des relations datées/versionnées. |
| **Modèle de persistance** | Repos sur un ORM (JPA, Hibernate) ou une couche repository orientée entités. | Repos sur un graphe append-only : les relations sont la donnée première, interrogeables par structure et contexte. |
| **Invariants** | Encapsulés dans les agrégats : un Order ne peut pas avoir deux OrderLines identiques, etc. | Définis comme règles de coexistence de relations : “par (Order, scope), une seule HAS_STATUS active”. |
| **Évolution du modèle** | Changement structurel : on refactore les entités, les DTO, les schémas. | Évolution additive : on introduit de nouvelles versions de liens (HAS_PRICE@v2) sans casser l’existant. |
| **Temporalité** | Rarement native (on ajoute un audit trail ou un event sourcing plus tard). | Intégrée nativement : chaque relation porte sa période (valid_from/to) ou son timestamp. |
| **Gestion du métier** | Règles exprimées dans des services métier (Application / Domain Services) manipulant des objets. | Règles exprimées comme fonctions pures : [relations₀] → fonction → [relations₁]. Chaque fonction dérive de nouvelles relations sans effet de bord. |
| **Communication entre domaines** | Context mapping, événements de domaine, intégrations asynchrones (souvent lourdes). | Relations croisées entre nœuds racines : pas besoin d’orchestration si les liens sont partagés et versionnés. |
| **Vision du système** | “Un réseau d’objets vivants” où chaque domaine protège sa cohérence interne. | “Un graphe de faits évolutifs” où chaque domaine contribue des relations au réseau commun. |
| **Responsabilité de l’état** | Chaque agrégat est responsable de sa cohérence interne et de son cycle de vie. | Chaque domaine est responsable des types de relations qu’il émet. La cohérence est systémique (invariants globaux). |
| **Historisation & audit** | Optionnelle (via Event Sourcing ou audit tables). | Native : les relations datées constituent l’historique. “Audit by design”. |
| **Lecture métier (Read model)** | Généralement par projections ou CQRS séparé. | Lecture = traversée de graphe : la composition des liens produit la vue. CQRS implicite. |
| **Complexité cognitive** | Modèle conceptuel riche, mais souvent difficile à stabiliser (aggrégats, règles implicites). | Modèle structurel simple : tout est fait de nœuds et de liens, avec un vocabulaire limité et uniformisé. |
| **Adaptabilité organisationnelle** | Très bon sur le papier, mais souvent rigide en pratique : les agrégats se figent vite. | Haute plasticité : les relations peuvent coexister, versionner, ou être remplacées sans rupture. |

---

## Ce que l’on conserve du DDD

✅ **Langage ubiquitaire** — Chaque domaine nomme ses relations selon son vocabulaire métier.  
✅ **Bounded Contexts** — Un domaine définit un espace de relations (`pricing.*`, `fulfillment.*`, etc.) et ses invariants.  
✅ **Événements de domaine** — Restent pertinents comme mécanisme de déclenchement pour produire de nouvelles relations.  
✅ **Isolations contextuelles** — Chaque module reste autonome pour sa logique métier, mais partage le graphe comme fondation.

---

## Ce que GDD dépasse ou remplace

🚫 **Les agrégats comme frontières physiques**  
→ remplacés par des ensembles cohérents de relations : cohérence par règles déclaratives, pas par encapsulation d’état.

🚫 **Les mutations d’entités**  
→ remplacées par des transitions append-only (nouveau lien, fin d’un autre).

🚫 **Le repository centré sur l’objet**  
→ remplacé par des requêtes de graphe (pattern matching, traversée).

🚫 **Les migrations douloureuses**  
→ versionner une relation = ajouter une nouvelle vérité, pas casser l’ancienne.

---

## Ce que GDD apporte en plus

- **Temporalité native** — chaque fait porte son contexte temporel (rejouable, auditable).  
- **Cohérence fluide** — les invariants sont définis globalement par structure, pas par encapsulation.  
- **Évolution incrémentale** — pas besoin de réécrire le passé, on ajoute de nouvelles versions.  
- **Interopérabilité simplifiée** — les liens forment une sémantique commune entre domaines.  
- **Lisibilité systémique** — le graphe se lit comme une carte du métier.  
- **Audit et simulation** — on peut rejouer ou simuler n’importe quel instant sans instrumentation.

---

## Synthèse

Le DDD reste une discipline d’analyse, un cadre mental pour comprendre et structurer le domaine.  
Le GDD en est une concrétisation alternative : il matérialise les invariants et les faits **dans la donnée elle-même**, plutôt que dans les objets.  

- DDD → cohérence par encapsulation  
- GDD → cohérence par structure et immutabilité  

L’un bâtit des objets robustes.  
L’autre tisse un graphe vivant de faits traçables et versionnés.  
Tous deux cherchent la même chose : **rendre la logique du métier explicite, maîtrisable et durable**.
