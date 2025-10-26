---
lang: en
---

# 🧩 DDD vs GDD (Graph-Driven Design)

English | [Français](../../fr/gdd/ddd-gdd.md)

## Introduction

This section explores the relationship between Domain-Driven Design (DDD) and the model we call GDD — Graph-Driven Design or the relational-functional model. Both aim to align technology with the business, but they do so differently: DDD encapsulates consistency inside aggregates, while GDD distributes it in the structure of relations.

---

## Comparison table

| Axis | **Domain-Driven Design (DDD)** | **Relational-Functional Model (GDD)** |
|------|----------------|----------------|
| **Modeling unit** | The entity or the aggregate: a coherent set of objects with identity and internal invariants. | The relation: a semantic fact linking stable root nodes. The unit of meaning is the link, not the object. |
| **Source of truth** | The state of an aggregate (objects and fields). We mutate internal state, then persist it. | Accumulated facts. We don’t mutate state; we add or replace dated/versioned relations. |
| **Persistence model** | Based on an ORM (JPA, Hibernate) or a repository layer centered on entities. | Based on an append-only graph: relations are the primary data, queryable by structure and context. |
| **Invariants** | Encapsulated in aggregates: an Order can’t have two identical OrderLines, etc. | Defined as coexistence rules across relations: “per (Order, scope), only one active HAS_STATUS.” |
| **Model evolution** | Structural change: refactor entities, DTOs, and schemas. | Additive evolution: introduce new versions of links (HAS_PRICE@v2) without breaking existing ones. |
| **Temporality** | Rarely native (audit trail or event sourcing added later). | Native: each relation carries its period (valid_from/to) or a timestamp. |
| **Business logic** | Rules expressed in business services (Application / Domain Services) manipulating objects. | Rules expressed as pure functions: [relations₀] → function → [relations₁]. Each function derives new relations without side effects. |
| **Inter-domain communication** | Context mapping, domain events, asynchronous integrations (often heavy). | Cross-relations between root nodes: no orchestration needed if links are shared and versioned. |
| **System view** | “A network of living objects” where each domain protects its internal consistency. | “A graph of evolving facts” where each domain contributes relations to the common network. |
| **State responsibility** | Each aggregate is responsible for its internal consistency and lifecycle. | Each domain is responsible for the types of relations it emits. Consistency is systemic (global invariants). |
| **Historization & audit** | Optional (via Event Sourcing or audit tables). | Native: dated relations constitute history. “Audit by design.” |
| **Business reads (Read model)** | Usually via projections or separate CQRS. | Reads = graph traversal: composing links produces the view. CQRS is implicit. |
| **Cognitive complexity** | Conceptually rich, but hard to stabilize (aggregates, implicit rules). | Structurally simple: everything is nodes and links, with a small, uniform vocabulary. |
| **Organizational adaptability** | Excellent on paper, often rigid in practice: aggregates ossify quickly. | High plasticity: relations can coexist, version, or be replaced without disruption. |

---

## What we keep from DDD

✅ **Ubiquitous Language** — Each domain names its relations using its own business vocabulary.  
✅ **Bounded Contexts** — A domain defines a space of relations (`pricing.*`, `fulfillment.*`, etc.) and its invariants.  
✅ **Domain Events** — Still relevant as triggers to produce new relations.  
✅ **Contextual isolation** — Each module remains autonomous for its business logic, yet shares the graph as foundation.

---

## What GDD replaces or goes beyond

🚫 **Aggregates as physical boundaries**  
→ replaced by coherent sets of relations: consistency through declarative rules, not state encapsulation.

🚫 **Entity mutations**  
→ replaced by append-only transitions (new link, end another).

🚫 **Object‑centric repositories**  
→ replaced by graph queries (pattern matching, traversal).

🚫 **Painful migrations**  
→ versioning a relation = adding a new truth, not breaking the old one.

---

## What GDD adds

- **Native temporality** — each fact carries its temporal context (replayable, auditable).  
- **Fluid consistency** — invariants are defined globally by structure, not by encapsulation.  
- **Incremental evolution** — no need to rewrite the past; add new versions.  
- **Simplified interoperability** — links form a common semantics across domains.  
- **System readability** — the graph reads like a map of the domain.  
- **Audit and simulation** — you can replay or simulate any instant without extra instrumentation.

---

## Summary

DDD remains an analysis discipline—a mental model for understanding and structuring the domain.  
GDD is an alternative concretization: it materializes invariants and facts in the data itself rather than in objects.

- DDD → consistency by encapsulation  
- GDD → consistency by structure and immutability  

One builds robust objects.  
The other weaves a living graph of traceable, versioned facts.  
Both aim for the same goal: making business logic explicit, manageable, and durable.

---

## See also

- Main essay: [From Bloated Tables to Functional Relations](./index.md)
