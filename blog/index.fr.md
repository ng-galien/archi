---
lang: fr
page_id: blog-index
title: Blog
permalink: /blog/
nav_section: blog
description: Billets courts, retours de terrain et notes de travail autour de GDD.
---

# Blog

Billets légers, annonces rapides et notes de recherche en cours.

{% assign localized_posts = site.posts | where: 'lang', page.lang %}
{% if localized_posts.size == 0 %}
_Aucun billet pour l’instant — les premiers arrivent bientôt._
{% else %}
<ul class="content-list">
  {% for post in localized_posts %}
  <li>
    <a class="content-list__title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <p class="content-list__meta">{{ post.date | date: '%d %B %Y' }}</p>
    <p class="content-list__description">{{ post.description }}</p>
  </li>
  {% endfor %}
</ul>
{% endif %}

<div class="section-note">Envie d’essais plus complets ? Parcourez les <a href="{{ '/fr/articles/' | relative_url }}">articles de fond</a>.</div>
