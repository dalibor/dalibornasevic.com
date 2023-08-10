---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

<div class='primary-avatar'>
  <img alt="Dalibor Nasevic" src="/assets/dalibor.nasevic.profile.jpg" title="Dalibor Nasevic">
</div>

<div class='primary-about'>
  Hello, my name is Dalibor Nasevic. I'm a <a href="https://www.linkedin.com/in/dalibornasevic" target="_blank" title="My LinkedIn profile">Sr. Principal Software Engineer</a> at <a href="https://www.godaddy.com" target="_blank">GoDaddy</a>, specializing in Ruby, AWS, and Email Delivery. I'm responsible for delivering billions of emails for internal partner teams and customers. I design, build and scale our email delivery platform that runs on AWS cloud infrastructure and on-premise. You can reach out to me via <a href="mailto:dalibor.nasevic@gmail.com" title="Email">email</a>.
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
