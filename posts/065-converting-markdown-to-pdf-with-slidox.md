---
id: 65
title: "Converting Markdown to PDF with Slidox"
date: 2016-02-09 21:30:00 +0100
author: Dalibor Nasevic
tags: [slidox, pdf, html, builder]
image: /images/slidox_screenshot.png
summary: "Slidox is a markdown to PDF and HTML conversion tool useful for building presentations and other documents."
---

I've had this small project called [Slidox](https://github.com/dalibor/slidox) laying around since [August 2014](https://github.com/dalibor/slidox/commit/7f67c6791c9b8c76da49402cbe4c5422181c7701). It was only yesterday when I noticed it and decided to spend few more hours to wrap it up and release it (backup the code on Github and Rubygems). Nothing fancy, just wiring up some simple Ruby tooling for converting Markdown to PDF with preference for syntax highlighting.

### The background

A [while back](/posts/47-markup-processing-and-code-syntax-highlight) I changed my blog to a new build process of markup processing and code syntax highlighting based on Github's preference to building HTML from Markdown. So, I thought why not use the same tools and build PDF from the HTML with [wkhtmltopdf](http://wkhtmltopdf.org/). Then, I have Slidox, an automated tool for building simple presentations and even small books.

### Dependencies and installation

Slidox has few system dependencies like `libicu-dev`, `cmake` and `wkhtmltopdf` (which is actually installed as a gem, wkhtmltopdf-binary).

Start by installing the system dependencies first:

```bash
sudo apt-get install libicu-dev
sudo apt-get install cmake
```

Then, install `slidox` gem:

```bash
gem install slidox
```

### Usage

Create new slidox project called `example`:

```bash
slidox new example
```

Then `cd` into the new directory with `cd example` and you will see the project structure:

```bash
├── assets
│   ├── elephants.jpg
│   ├── jellybeans.css
│   ├── line_numbers.css
│   ├── main.css
│   └── OpenSans-Light-webfont.ttf
├── config.yml
└── slides
    ├── 1.md
    └── 2.md
```

The `assets` directory contains basic styles to get you started. `slides` dir is where you add the slides to build. `config.yml` contains few configutation options for the PDF export from [pdfkit](https://github.com/pdfkit/pdfkit) and build targets for both HTML and PDF formats.

To build the project:

```bash
slidox build
```

Then, Slidox creates new `build` directory with HTML and PDF files inside. Here's the PDF preview:

<p style="text-align: center">
  <img src="/images/slidox_screenshot.png" alt="Slidox PDF build screenshot">
</p>

You can find more syntax highlighting [themes](https://github.com/cstrahan/pygments-styles/tree/master/themes) and read this [blog post](/posts/47-markup-processing-and-code-syntax-highlight) for more info on the tools used.
