---
lang: en
---

# From Bloated Tables to Functional Relations: Toward a More Natural, Evolvable Data Model

English | [Français](../../fr/gdd/index.md)

## Introduction

In software engineering, data modeling sits at the heart of any information system. Yet as systems evolve and business needs change, many end up accumulating unnecessary complexity, leading to rigid structures that are hard to maintain. This paper explores a recurring problem—“table obesity” in relational databases—and proposes an alternative inspired by graphs, enriched with a functional perspective. Based on real-world observation, we develop the core ideas showing how shifting variability to relations and pure transformations can make models more business-aligned, readable, and robust.

This approach does not reject traditional relational databases; it complements them with a more fluid way of thinking that fits how development teams actually work. We first diagnose the problem, then present the graph alternative, and finally outline a functional extension that treats business as a flow of immutable relations. Concrete examples and practical implications illustrate each point.

## Field Reality: A Dominant Data‑First Reflex

In practice, development teams often approach business problems through the lens of concrete data rather than abstract concepts. When a new need emerges—say, adding promotions to products in an e‑commerce system—the first question is rarely “What’s the underlying business concept?” but rather “Which columns do we add to the Product table?” This feels reassuring: it’s tangible, grounded in the existing system, and enables quick prototyping.

However, this data‑first bias has long‑term consequences. By reasoning in static structures, business logic ends up subordinated to the database. Tables become living archives of historical compromises: a field added for a temporary exception, a status for a seasonal variant, a boolean for an edge case. Over iterations, this creates invisible technical debt where structure dominates semantics. In real projects (CRM, ERP), this leads to cognitive fragmentation: developers spend more time navigating complex schemas than implementing business value.

A concrete example: a Customer table starts simple (id, name, email). As subscriptions, marketing preferences, or multiple addresses are added, nullable columns appear (subscription_end_date, marketing_opt_in) or JSON blobs are used “for flexibility.” The table bloats, and the associated code (SQL queries, ORM mappings) turns into a maze of null checks and inconsistency handling.

## Table Obesity: Symptoms and Consequences

In most mature systems, giants like Product, Customer, or Order appear. They begin simple with a handful of essential columns. Over time, they gain “weight”: more than 100 columns, half of them nullable, added to accommodate each new requirement without rethinking the model.

Common signs:

- Excessive nullability: optional fields everywhere, forcing code to be full of guards (if not null). Higher runtime risk and test complexity.
- Contradictory columns: multiple ways to express the same idea (e.g., an “active” status and an “is_deleted” flag), creating logical inconsistencies.
- Massive objects: entities become bags of optional fields, making domain objects (DTOs, entities) heavy and unexpressive.
- Global fragility: any change—adding a field—threatens existing behaviors because dependencies are hidden in legacy code.

Consequences include degraded performance (too many indexes, unnecessary scans) and a steep learning curve for newcomers. Business‑wise, the table no longer reflects a dynamic reality but a sedimentation of fixes. For instance, an Order table may accumulate columns like promo_code (nullable), discount_amount (derived but stored), causing redundancy and update bugs.

This isn’t inevitable; it follows from a modeling approach that forces variability inside entities instead of their interactions.

## Limits of Traditional Conceptual Models

Approaches like Domain‑Driven Design (DDD) or hexagonal architecture re‑center the business by modeling aggregates, entities, and value objects. They encourage a clear separation between domain logic and persistence via repositories.

Yet these methods require mature team practices: modeling workshops, discipline around bounded contexts, and tolerance for abstraction. In many teams—constrained by deadlines, junior staffing, or heavy legacy—data‑first persists because it’s more immediate. Rather than fight this reflex, it’s more pragmatic to adapt it by providing a more flexible frame that starts from data but keeps it evolvable.

## The Alternative: Think in Graphs to Move Variability

Graph databases (like Neo4j) treat relations as first‑class citizens. Instead of bloating tables, keep simple nodes (Product, Customer, Order) and express variability through links: HAS_PRICE (with attributes like amount, currency), PLACED_BY (with date, channel), HAS_STATUS (with value, timestamp).

Key idea: absence of a link naturally stands in for null. No HAS_PROMO? No active promotion. This eliminates unnecessary nulls and keeps the model coherent. Each relation can carry its metadata (validity dates, context), enabling fine‑grained modeling without mutating core entities.

Concrete effects:

- Better readability: the graph describes the domain through interconnected structure rather than an accumulation of fields.
- Easier evolution: adding a link (e.g., HAS_RECOMMENDATION) doesn’t break anything; it’s a non‑intrusive extension.
- Clearer code: small, non‑nullable domain objects that fit well with builders and immutables.
- Business conversations: teams speak in terms of relations (“How do we link this product to that customer?”), better aligning with business language.

Developed example: in e‑commerce, instead of a Product table with 50 columns, use a Product node linked to PRICE (valid for a period), CATEGORY, SUPPLIER. A promotional price query becomes a graph traversal: Product → HAS_PROMO → DISCOUNTED_PRICE with filters on link attributes.

This change doesn’t remove complexity; it makes it manageable: links can be dated, versioned, and contextualized, telling the story of interactions without merging entities. The model evolves by extension, not destructive mutation.

## Functional Extension: Business as Relation Transformations

Go further by viewing business not as static state but as a flow of transformations over relations. Most business rules boil down to: take a set of existing relations and derive new ones.

Example: a pricing calculation transforms links (Product → CHANNEL → PERIOD) into a new relation HAS_EFFECTIVE_PRICE. An order validation derives DELIVERABLE from (Order → ITEMS → STOCK). This aligns with functional programming: pure functions (no side effects), immutable, taking relational inputs and producing outputs without altering the past.

Existing relations tell the past; new ones describe the present. A business journey becomes a composition: [relations₀] → function1 → [relations₁] → function2 → [relations₂]. Persistence is just synchronization: accumulate facts (append‑only) rather than overwrite history.

Benefits:

- Predictability: each function is deterministic and testable in isolation, reducing bugs.
- Traceability: the history of transformations offers natural auditability, useful for compliance (e.g., GDPR).
- Business alignment: we think in flows (“Transform this contract into a re‑evaluated status”), which reads more clearly and robustly.

Insurance example: a pure function takes (Contract → CLAIM → COVERAGE) and yields a new relation HAS_CLAIM_STATUS, composable with others (e.g., for a payment).

## Conclusion

This combined approach—graphs for structure, pure functions for logic—complements relational modeling rather than replacing it. It offers a gentle evolution suited to data‑first teams, making variability manageable and aligned with business reality. In a world of interconnected, dynamic data, adopting this mindset can reduce technical debt and foster innovation. To implement, start with a POC in a sub‑domain, using hybrid tools (PostgreSQL with graph‑like extensions, or Neo4j alongside). How will you apply these ideas in your projects? This paper invites ongoing reflection toward living, natural models.

## See also

- Comparison: [DDD vs GDD](./ddd-gdd.md)
