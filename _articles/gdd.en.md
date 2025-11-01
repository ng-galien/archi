---
lang: en
page_id: article-gdd
title: From Bloated Tables to Functional Relations
description: Reflection on Graph‑Driven Design and relation‑centric data modeling.
permalink: /articles/gdd/
nav_section: articles
weight: 10
---

# From Bloated Tables to Functional Relations: Toward a More Natural, Evolvable Data Model

{% comment %} Mirror of the FR article. Keep structure/headings in lockstep. {% endcomment %}

## Introduction

Data modeling sits at the heart of any information system. Yet as systems evolve and needs shift, many accumulate unnecessary complexity, leading to rigid structures that are hard to maintain. This article explores a recurring issue—“table obesity” in relational databases—and proposes an alternative inspired by graphs and the functional paradigm.

The goal is not to reject relational databases, but to show how shifting variability to relations can make models more natural, adaptive, and faithful to business reality.

We will look at:
- the field bias toward data‑first thinking,
- the symptoms of table obesity,
- the limits of OO/DDD in practice,
- the graph‑ and relation‑centric alternative,
- a functional extension where business is a flow of transformations,
- and GDD’s compatibility with modern architectures.

---

## 1. Field Reality: A Dominant Data‑First Reflex

In most teams, when a need appears, the reflex question is:
> “What do we add to the table?”

This data‑first reflex feels natural: it gives a concrete starting point. Yet it nudges us to think through structure rather than meaning.

Over time, this creates a gap between the model and the business. Tables become archives of compromises: a field for a temporary case, a boolean for an exception, a JSON blob for an urgent need. The result is a rigid structure where each addition complicates the system instead of clarifying it.

### Organizational consequence

Teams spend more time managing schemas than reasoning about the business. Every change becomes heavy—migrations, tests, ORM refactors. This structural debt slows down adaptation, the opposite of what an information system should provide.

---

## 2. Table Obesity: Symptoms and Consequences

In most mature systems, some tables grow monstrous: Product, Customer, Order. They start simple and swell over time, sometimes to hundreds of columns—many half‑nullable.

### Typical symptoms

- Excessive nullability: optional fields everywhere.  
- Contradictory columns: `is_deleted` vs `active` with no clear rule.  
- Massive objects: entities turn into bags of optional fields.  
- Diffuse coupling: any evolution risks breaking others.

### Impact on code

Code grows heavier as the model deforms: omnipresent `if not null` checks, overloaded ORMs, bulky DTOs. Maintenance becomes archaeology. New developers spend weeks uncovering hidden relations between columns and statuses.

---

## 3. The Limits of Classic DDD

Domain‑Driven Design (DDD) is invaluable: it centers the business, isolates invariants, and promotes a ubiquitous language. But it assumes a degree of stability and team maturity that’s rare in day‑to‑day reality.

Aggregates—meant as coherence boundaries—quickly become mini opaque systems. The need for flexibility pushes teams to bypass them with flags, artificial links, and ill‑defined transient states.

### Tension between ideal and practice

DDD aims for rigor, which can feel heavy when the domain changes constantly. GDD doesn’t replace DDD; it extends it by moving coherence from the object to the relation.

---

## 4. The Alternative: Think in Graphs

Graph stores like Neo4j or PGGraph consider relations as first‑class citizens alongside entities.

Instead of a `Product` table with 50 columns, keep a simple `Product` node and connect it to facts through links:

```text
[Product] --HAS_PRICE--> [Price]
		  --HAS_PROMO--> [Promotion]
		  --IN_CATEGORY--> [Category]
```

### The “absent link” as semantics

The absence of a link becomes information: no active promo, no price for this channel. This explicit semantics removes most `NULL`s and makes business reading more direct.

### Natural reading

Graphs mirror how we think: we explore relations and contextualize facts. A business query becomes a traversal:
> “Which products have an active promotion in the ‘summer’ category with a price under 50?”

### An intuitive approach before it is technological

Thinking in graphs is not enough; we still have to decide where variability should live. This is where the notion of stability—or the “temperature” of data—helps separate structural elements from dynamic ones.

### Principle of stability and data temperature

Not all data carries the same nature, nor the same “heat.” Some elements are stable, almost structural: they describe what an entity *is*. Others are dynamic and ever‑changing: they describe what an entity *does* or what *happens* to it.

In a graph‑driven perspective this principle is fundamental: we treat cold attributes and hot facts differently.

- **Cold data** (stable) rarely changes. It belongs to the node and represents the identity or essential properties of the entity.  
- **Hot data** (mutable) reflects a state, a relation, or an event. It should live in the relations, because relations tell the story of how the domain evolves.  

This principle guides the decision of what deserves to be a relation:  
> Can this data change independently of the entity?  
> Is it contextual or time‑bound?  
> Does it make sense only through its link to other elements?  

If the answer is yes, it deserves to exist as a relation. Otherwise, it stays as a node property.

This principle creates a natural hierarchy in the graph:
- **Cold nodes** capture the essence of things.  
- **Hot links** capture the life and interactions of the domain.  

The distinction avoids over‑generalization: the graph remains expressive without becoming overloaded. It also introduces an implicit temporal dimension: the hotter the data, the more likely it is to evolve or be versioned.

### Relationships and hypermedia navigation

In a GDD system, relations become natural carriers for hypermedia links (or any link‑based protocol). A relation is already an expression of dynamic context: it joins two entities at a given moment under a precise meaning (`HAS_STATUS`, `IS_MEMBER_OF`, `CAN_ACCESS`).

That is exactly what hypermedia aims to describe: contextualized links between resources that carry intent and semantics.

### Relations as business actions

Put differently:
- a **node** models a stable resource,
- a **relation** models a possible action or state,
- and **hypermedia** is simply a navigable materialization of those relations.

From that angle, GDD offers a unified conceptual base between the data model and the communication model. The links exposed by the API are no longer mere technical metadata; they are a direct reflection of the business graph.

Such an architecture is not a thin layer on top of the graph; it is the graph’s natural extension. Clients no longer navigate endpoints—they navigate the relations that bring the domain to life.

We can refine the idea by distinguishing two kinds of navigation in hypermedia:

- **State modifications** target **cold data**. They correspond to what we find in classic REST models: updates or replacements of the resource (`PUT`, `PATCH`, `DELETE`). They modify the stable part of the entity.  
- **Relations**, meanwhile, embody **actions on the resource**. They are the real business methods: they do not mutate the object directly but express a transition or interaction (`/approve`, `/assign`, `/cancel`, etc.). In that sense, a relation becomes the hypermedia equivalent of a method, linking current state to potential state.  

The separation between cold data (state) and relations (actions) mirrors the separation GDD enforces in the model: the graph does not just describe the world, it describes **how the world can evolve**.

GDD does not mandate a graph database. You can build a graph/relational architecture on top of a traditional RDBMS (PostgreSQL, MariaDB, and so on): tables for nodes, tables for relations, materialized views for traversals.

The real change happens in the mental model. In a graph mindset we naturally:
- place **variability** in the **relations** (the links between facts or states),  
- treat entities as the **stable anchors** of the domain,  
- evolve the system by **adding links** rather than mutating fields.  

By contrast, a classic model tends to aggregate states inside a single entity, producing objects that accumulate mutable fields whose coherence becomes harder to preserve.

This mental posture has a major impact: it leads us to view business evolution as a succession of relational facts instead of repeated mutations of a single centralized state.

---

## 5. Functional Extension: Business as a Flow of Relations

Inspired by FP, view the business as a transformation of relations. Each rule is a pure function that takes a set of links as input and produces others as output.

```text
[relations₀] → function1 → [relations₁] → function2 → [relations₂]
```

Examples:
- Computing an effective price combines `HAS_PRICE` and `HAS_PROMO`.
- Order validation derives `IS_DELIVERABLE` from `HAS_STOCK` and `HAS_ADDRESS`.

### Key properties

- Immutability: don’t overwrite; append a new link.  
- Traceability: each transformation is a historized fact.  
- Testability: a business function is testable in isolation, as it only depends on its inputs.

---

## 6. Versioning and Compatibility

One major benefit of GDD is relation versioning. A link can exist in multiple versions (`HAS_PRICE@v1`, `HAS_PRICE@v2`) representing business evolution without breaking changes.

### Advantages

- Immediate rollback: return to a previous version without data migrations.  
- Canary releases: coexist several versions for progressive validation.  
- Continuous evolution: the model grows by addition, not erasure.

This enables structural agility: the domain evolves by addition, not destruction.

---

## 7. Working with DDD, Not Against It

DDD and GDD address different moments in design.

| Aspect | DDD | GDD |
|---|---|---|
| Unit of modeling | Aggregate / entity | Relation |
| Coherence | Encapsulation | Structure + global invariants |
| Temporality | Optional | Native |
| Evolution | Refactoring | Versioning |
| Auditability | Added | Natural |

DDD structures thinking; GDD structures data. One encapsulates, the other exposes. Together they offer a view that’s both rigorous and fluid.

---

## 8. GDD in a Microservices Environment

In distributed architectures, each microservice manages a sub‑graph. Root nodes (`Customer`, `Product`, `Order`) are shared; each service defines its specialized relations (`pricing.*`, `fulfillment.*`, `marketing.*`).

### Concrete benefits

- Logical decoupling without data duplication.  
- Stable identity: no need for cross‑database primary keys.  
- Business autonomy: each team evolves its relational space without breaking others.  
- Systemic coherence: ensured by structure and invariants, not distributed transactions.

The graph becomes a common substrate where each domain adds its semantic layer.

---

## 9. Conclusion

Graph‑Driven Design doesn’t replace relational models or DDD—it extends them. By centering relations, it:
- frees variability,
- captures business history,
- and aligns technical structure with the language of facts.

In fast‑moving domains, GDD offers a more natural path: a system that tells its own story through its relations.

---

### See also

- Comparison: [DDD vs GDD]({{ '/articles/ddd-vs-gdd/' | relative_url }})
- Case study: [Applying GDD to an Insurance Domain]({{ '/articles/apply-gdd/' | relative_url }})
