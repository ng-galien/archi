---
lang: en
page_id: articles-index
title: Deep Dives
permalink: /articles/
nav_section: articles
description: Long-form essays on graph-driven modeling and data architecture.
---

# Deep-Dive Articles

Longer-form explorations of software design and architecture.

{% assign localized_articles = site.articles | where: 'lang', page.lang | sort: 'weight' %}
{% if localized_articles.size == 0 %}
_No articles yet — check back soon._
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

<div class="section-note">Prefer lighter updates? Visit the <a href="{{ '/blog/' | relative_url }}">blog</a>.</div>
