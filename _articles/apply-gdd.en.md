---
lang: en
page_id: apply-gdd
title: Applying Graph‑Driven Design to an Insurance Domain
description: Case study — modeling contracts, claims, and coverages with a graph‑oriented approach.
permalink: /articles/apply-gdd/
nav_section: articles
weight: 11
---

# Applying Graph‑Driven Design to an Insurance Domain

## Introduction

Insurance systems are among the hardest to model: each insured person, contract, claim, and coverage interacts over time under many rules.  
Traditional relational approaches often struggle to express this richness. They freeze business into tables, while the domain naturally evolves through relations between facts.

This article gives a concrete comparison between:
- a **classic SQL model**, centered on entities (`Contract`, `Claim`, `Coverage`), and
- a **graph‑oriented model**, centered on **fact relations** (`HAS_CONTRACT`, `HAS_COVERAGE`, `HAS_CLAIM_STATUS`, etc.).

The goal isn’t to oppose the two, but to show how the latter enables a more fluid, historical, and functional reading of the domain.

---

## 1. Reference domain

Each customer holds one or more **contracts**, each covering specific risks.  
When a **claim** occurs, it’s attached to a contract, evaluated, then indemnified.  
These elements evolve over time: coverages change, claim statuses follow one another, and contracts renew.

Main notions:
- **Customer**
- **Contract**
- **Coverage**
- **Claim**
- **Status**
- **Validity period**

---

## 2. Classic relational modeling

In a traditional SQL schema, several tables are created and tied via foreign keys:

```sql
CUSTOMER(id, name, birth_date, address, ...)
CONTRACT(id, customer_id, type, start_date, end_date, status, ...)
COVERAGE(id, contract_id, type, amount, ...)
CLAIM(id, contract_id, claim_date, amount, status, indemnification_date, ...)
```

### Observed limits

- **Temporality** is implicit: periods are encoded in columns (`start_date`, `end_date`) rather than made first‑class.  
- **Variability** (new coverages, statuses, or products) forces migrations and refactors.  
- **History** is fragmented: to know a contract’s state at a given date, you must cross tables and filters.  
- Required **joins** to answer simple questions grow heavy and fragile as the domain evolves.

---

## 3. Graph‑oriented modeling (GDD)

**Graph‑Driven Design** moves variability into relations rather than entities.  
We keep stable root nodes:

```text
[Customer]      [Contract]      [Claim]      [Coverage]
```

And we describe the domain through **fact relations**:

```text
[Customer] --HAS_CONTRACT--> [Contract]
[Contract] --HAS_COVERAGE--> [Coverage]
[Contract] --HAS_CLAIM--> [Claim]
[Claim] --HAS_STATUS--> [Status]
[Contract] --VALID_DURING--> [Period]
```

Each relation carries its context:
- temporal (`valid_from`, `valid_to`)
- semantic (`type`, `scope`, `version`)
- and sometimes contractual (`channel`, `policy_id`).

### Natural reading

A business query becomes a graph exploration.  
For example:  
> “Find claims attached to a contract active on March 15, 2024.”

```cypher
MATCH (c:Contract)-[r:HAS_CLAIM]->(cl:Claim)
WHERE r.valid_from <= date('2024-03-15')
  AND (r.valid_to IS NULL OR r.valid_to >= date('2024-03-15'))
RETURN cl;
```

This follows the business flow without multiple joins: the graph tells the facts instead of reconstructing them.

---

## 4. Historical reading example

### In classic SQL

> “What was claim #512’s status on March 15, 2024?”

```sql
SELECT status
FROM CLAIM
WHERE id = 512
  AND claim_date <= '2024-03-15';
```

This assumes status is a single (thus volatile) column.  
You lose the sequence of changes.

### In a GDD model

> “Which `HAS_STATUS` link was valid for claim #512 at that date?”

```cypher
MATCH (c:Claim {id: 512})-[r:HAS_STATUS]->(s:Status)
WHERE r.valid_from <= date('2024-03-15')
  AND (r.valid_to IS NULL OR r.valid_to >= date('2024-03-15'))
RETURN s;
```

Here, history is native.  
Each `HAS_STATUS` relation represents a temporal truth, and all coexist without overwriting.

---

## 5. Functional reading: business as a flow of transformations

Under the functional paradigm, each rule is a pure function deriving new relations.

```scala
f_evaluate_claim :
  [HAS_CONTRACT, HAS_COVERAGE, HAS_CLAIM] → [HAS_INDEMNIFICATION]
```

Each transformation creates new links rather than mutating the old ones:

```scala
relations₀
  → f_validation
  → f_indemnisation
  → f_cloture
```

This promotes:
- **testability**: each function is deterministic;  
- **traceability**: produced facts are timestamped and versioned;  
- **replayability**: re‑evaluate functions over history.

---

## 6. Comparative advantages

| Aspect | SQL model | GDD model |
|---|---|---|
| Temporality | Columns and constraints | Native in relations |
| History | External audit or triggers | Historized by design |
| Evolution | Frequent migrations | Add new relations |
| Business reading | Complex joins | Logical traversal |
| Audit/compliance | Dedicated tools | Audit by design |

---

## 7. Systemic view

The customer’s dossier becomes a **living graph**: a set of facts coherent over time.  
Each relation expresses a moment of truth.  
Together, they form a **navigable story**:

```text
(Customer) --HAS_CONTRACT--> (Contract)
          --HAS_CLAIM--> (Claim)
               --HAS_STATUS--> (Status)
```

Instead of hunting for a single “state of the world”, we read the transitions that build it.

---

## Conclusion

Graph‑Driven Design doesn’t try to simplify the domain; it represents it in **motion**.  
Rather than piling up frozen states, it captures facts and their relations.  
In domains where each decision depends on context and history, this approach makes the model both truer and easier to read.

---

### See also

- Comparison: [DDD vs GDD]({{ '/articles/ddd-vs-gdd/' | relative_url }})
- Case study: [Applying GDD to an Insurance Domain]({{ '/articles/apply-gdd/' | relative_url }})
