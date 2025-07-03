---
layout: post
title: "I Still Use Vim. I Also Use AI. It Still Feels Like Me."
date: 2025-07-03 10:20:00 +0200
categories: [ai, reflection, godaddy, productivity]
summary: This post is a personal reflection on how I've integrated AI into my day-to-day work as a software engineer, what I've learned from it, and how I see it shaping the way we work.
permalink: /posts/87-i-still-use-vim-i-also-use-ai-it-still-feels-like-me
featured: true
---

_This blog post was originally published on the [GoDaddy Engineering Blog](https://www.godaddy.com/resources/news/i-still-use-vim-i-also-use-ai-it-still-feels-like-me)._

<p style="text-align: center">
  <img src="/images/i-still-use-vim-i-also-use-ai-it-still-feels-like-me/cover.jpg" alt="Photo of a bird in the foreground standing in shallow water with mountains in the background">
</p>

I still write code in Vim. I still get excited when I build something that works. Lately, AI has become an essential part of how I get there.

At GoDaddy, we're embracing AI across the company. Engineers are encouraged to explore how AI can boost productivity, creativity, and velocity. We have access to a wide range of tools, the most popular for engineers being GitHub Copilot, Cursor AI, Claude Code, and local LLMs via Ollama and LM Studio.

This post is a personal reflection on how I've integrated AI into my day-to-day work as a software engineer, what I've learned from it, and how I see it shaping the way we work.

## Getting into AI, one use case at a time

I work on GoDaddy's email delivery platform which spans infrastructure, backend APIs and messaging systems. My AI journey started simply with some quick searches, queries for second opinions, and lightweight brainstorming. Over time, that evolved into using AI to solve coding problems in languages I'm less familiar with, write tests, or even fully delegate some tasks when the risk is low and the confidence is high.

People have strong opinions about AI. Some still ignore it completely or don't fully get what it's capable of. Others argue it has taken the fun out of engineering, replacing deep thinking with shallow prompting.

For me, solving problems isn't the most interesting part. What excites me is building and creating something. As long as I understand what's going on under the hood, I find AI incredibly helpful in that process. With the right mindset, it doesn't replace my work, it just helps me move faster and with more confidence.

## What's in my toolbox

I've spent time exploring tools like GitHub Copilot, Cursor AI, and Claude Code. I've also experimented with local models using Ollama and LM Studio and rely on ChatGPT, Gemini, or Claude for quick questions or longer analyses. I've also built some local agents using local models and tools, and explored building and running local MCP servers.

When it comes to writing code, I prefer Claude Code. We use the models through Amazon Bedrock, which provides an added layer of security, privacy, and safety. It works well in the terminal and doesn't enforce a built-in editor, which is ideal since I prefer working in Vim rather than switching to a full IDE.

Not all tools are equal, though. A lot depends on how well the tool sets up context for the model, so in addition to testing different models, it's valuable to compare how each tool interacts with them. I've seen some models hallucinate or loop on vague prompts, especially when trained on incomplete data. For example, when working with AWS Network Load Balancer security groups, which were introduced in 2023, some tools gave inaccurate and overly complex suggestions no matter how I phrased the question, while others nailed it on the first try.

## Where AI actually helps

Here are some of the most successful ways I've used AI:

- Converting an AWS CDK project from JavaScript to TypeScript
- Writing code and tests in languages where I'm less proficient
- Writing Swagger specs for existing APIs
- Establishing a pattern and having AI replicate it
- Rubber duck debugging where AI hallucinations spark new ideas
- Summarizing or reviewing PRs using GitHub Copilot
- Drafting interview scorecards from raw notes
- Replacing traditional web searches with conversational queries
- Translating content from my native language to English and polishing it, including this blog post

## AI is not a shortcut

Lately I've been working on a new project for inbound email. It involves setting up new infrastructure, integrating new APIs for mailbox registration with an edge SMTP server, connecting it to the backend SMTP, and implementing new functionality into an existing system that previously only supported outbound email.

A big part of the challenge is designing new database tables, queues, data flows, validations, and callback systems that all need to integrate smoothly with the existing architecture, work within its constraints, and scale effectively. This process requires deep thinking, synthesizing information, and what I'd call design intuition. I've had several mornings where I woke up with a new idea or realized I had missed something important the day before.

And that's the point. AI can help spark ideas quickly, even when my prompt isn't perfect. It doesn't need a full specification to start being useful. While it can boost productivity, it can also create false confidence, which may become risky and costly.

In software, one of the biggest costs is often changing existing systems. That's where time and budget can quickly disappear. Reducing that cost requires thoughtful design and planning up front. Poor decisions made early, especially under time pressure, tend to resurface later as expensive rework or maintenance. Spending time on architecture may seem slow at first, but it helps avoid bigger problems down the road.

We still need to understand what we're building and use AI to support our thinking, not to skip over it. Otherwise, we risk becoming faster at going in the wrong direction. There's also the issue of cognitive debt (the gradual erosion of understanding when we depend on AI without fully grasping the underlying concepts), which is explored in more detail in a recent [study](https://arxiv.org/abs/2506.08872).

## What's changing in how we work

We're entering a phase where engineers are acting more like orchestrators or reviewers. Our judgment, product intuition, and ability to manage complexity are becoming more important than how quickly we can write or refactor code (and yes, I still whisper an apology to Vim when AI fills in a line). Blindly applying best practices without understanding context is a failure of our responsibility as engineers.

AI is only going to improve and will continue to change how we work. Roles are starting to blend. With the help of AI, I can move seamlessly between writing, designing, prototyping, analysis, coding, and infrastructure automation without breaking my flow. It doesn't make decisions for me, but it helps me reach better ones faster. I'm still in control, it simply sharpens my thinking and speeds up the process.

## What still matters

There are two things I learned early in my career that still hold true today.

1. __Programming is a marathon.__
Strategy matters more than short-term wins. You can be great at problem-solving, but without a long-term view it doesn't get you far. Thinking ahead is what sets you apart. Today that means embracing AI and finding ways to adapt without losing your edge.

2. __Find what you enjoy.__
Do the work that excites you, and the rest tends to work itself out. Stay curious and stay interested. Don't lose that spark, even when the tools around you are changing fast.

## Conclusion

Like many engineers, I’m still figuring out where AI fits best. But what’s clear is that it works best when it complements the way I already like to build software. It helps me move faster, stay in flow, and focus more on the parts of the work I enjoy, without losing the parts that matter most.

Photo by <a href="https://unsplash.com/@pagsa_?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Pablo García Saldaña</a> on <a href="https://unsplash.com/photos/bird-drinking-water-EOxpS6yBQU4?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
