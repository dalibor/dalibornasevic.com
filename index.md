---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<div class='primary-avatar'>
  <img alt="Dalibor Nasevic" src="/assets/dalibor.nasevic.profile.jpg" title="Dalibor Nasevic">
</div>

<div class='primary-about'>
  <a href="https://www.linkedin.com/in/dalibornasevic" target="_blank" title="My LinkedIn profile">Senior Principal Engineer</a> at <a href="https://www.godaddy.com" target="_blank">GoDaddy</a>, specializing in Ruby, AWS, and Email Delivery. I have built a highly scalable and available, cloud-ready email delivery platform that runs on AWS infrastructure and on-premise, delivering billions of customer emails. Reach out to me via <a href="mailto:dalibor.nasevic@gmail.com" title="Email">email</a> or tweet me at <a href="https://twitter.com/dnasevic" title="Twitter" target="_blank">@dnasevic</a>.
</div>

{%- if site.posts.size > 0 -%}
<div class='primary-posts'>
  <h2 class="post-list-heading">Featured Blog Posts</h2>
  <ul class="post-list">
    {%- for post in site.posts -%}
      {%- if post.featured -%}
        <li>
          {%- assign date_format = site.minima.date_format | default: "%b %-d, %Y" -%}
          <span class="post-meta">{{ post.date | date: date_format }}</span>
          <a class="post-link" href="{{ post.url | relative_url }}">
            {{ post.title | escape }}
          </a>
        </li>
      {%- endif -%}
    {%- endfor -%}
  </ul>
</div>
{%- endif -%}
