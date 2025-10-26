---
lang: en
page_id: blog-index
title: Blog
permalink: /blog/
nav_section: blog
description: Short takes, changelog entries, and field notes around GDD.
---

# Blog

Bite-sized notes, changelog entries, and experiments in progress.

{% assign localized_posts = site.posts | where: 'lang', page.lang %}
{% if localized_posts.size == 0 %}
_No posts yet — first entries coming soon._
{% else %}
<ul class="content-list">
  {% for post in localized_posts %}
  <li>
    <a class="content-list__title" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    <p class="content-list__meta">{{ post.date | date: '%B %d, %Y' }}</p>
    <p class="content-list__description">{{ post.description }}</p>
  </li>
  {% endfor %}
</ul>
{% endif %}

<div class="section-note">Looking for deep dives? Explore the <a href="{{ '/articles/' | relative_url }}">long-form articles</a>.</div>
