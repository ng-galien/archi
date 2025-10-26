---
lang: fr
page_id: articles-index
title: Articles de fond
permalink: /articles/
nav_section: articles
description: Essais approfondis sur la modélisation orientée graphes et l'architecture de données.
---

# Articles de fond

Retrouvez ici les essais fouillés sur le design logiciel et la modélisation de données.

{% assign localized_articles = site.articles | where: 'lang', page.lang | sort: 'weight' %}
{% if localized_articles.size == 0 %}
_Aucun article pour le moment — revenez bientôt._
{% else %}
<ul class="content-list">
  {% for article in localized_articles %}
  <li>
    <a class="content-list__title" href="{{ article.url | relative_url }}">{{ article.title }}</a>
    <p class="content-list__description">{{ article.description }}</p>
  </li>
  {% endfor %}
</ul>
{% endif %}

<div class="section-note">Vous cherchez un format plus court ? Direction le <a href="{{ '/fr/blog/' | relative_url }}">blog</a>.</div>
