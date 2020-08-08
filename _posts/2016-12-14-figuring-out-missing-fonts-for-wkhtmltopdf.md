---
layout: post
title: "Figuring out missing fonts for wkHTMLtoPDF"
date: 2016-12-14 23:30:00 +0100
categories: [ruby, tools, linux]
summary: "Figuring out missing fonts for Hebrew, Arabic, Chinese, Korean and Japanese for wkHTMLtoPDF."
permalink: /posts/76-figuring-out-missing-fonts-for-wkhtmltopdf
---

[wkHTMLtoPDF](http://wkhtmltopdf.org/) is a great tool for building PDFs from HTML and CSS using the Qt WebKit rendering engine. It's much more convenient than using a PDF generation tool and drawing things from scratch.

There is a Ruby wrapper for wkHTMLtoPDF called [PDFKit](https://github.com/pdfkit/pdfkit) that's handy. Once you have wkHTMLtoPDF binary and gem installed, using PDFKit is very simple:

```ruby
PDFKit.new(html_content, page_size: 'Letter').to_pdf
```

I had an issue in production with missing characters in the PDF render and with some character sets the characters were displayed as squares or similar weird characters. Locally, the PDF render was rendering and displaying the characters properly that was a good starting point to do some comparison and figure out the missing fonts which I'll document here.

Local OS version:

```bash
$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=14.04
DISTRIB_CODENAME=trusty
DISTRIB_DESCRIPTION="Ubuntu 14.04.5 LTS"
```

Production OS version:

```bash
$ cat /etc/redhat-release
CentOS release 6.7 (Final)
```

After few tests I noticed that the issue is happening for Hebrew, Arabic, Chinese, Korean and Japanese, and not for Cyrillic characters for example.

I did a test with ASCII only characters and compared the PDF source output locally and in production. The font that was selected to use in the PDF was `Nimbussanl Regular` for both. Here is a segment from the PDF source of the render for the `FontName`:

```bash
<< /Type /FontDescriptor
/FontName /QEBAAA+NimbusSanL-Regu
```

When using Cyrillic characters, PDF render source shows that the same font is selected which is probably because that default font has support for Cyrillic characters too.


### Hebrew, Arabic and Greek

When testing with these character sets, here are fonts selected locally for each respectively:

```bash
# Hebrew
/FontName /QKBAAA+DejaVuSans
# Arabic
/FontName /QKBAAA+DejaVuSans
# Greek
/FontName /QKBAAA+LiberationSans
```

CentOS package for that font I had locally is `dejavu-sans-fonts` and after installing it `sudo yum install dejavu-sans-fonts`, wkHTMLtoPDF is selecting it instead the default `Nimbussanl Regular` font which fixes the issue for these 3 character sets.


```bash
# Hebrew
/FontName /QKBAAA+DejaVuSans
# Arabic
/FontName /QKBAAA+DejaVuSans
# Greek
/FontName /QKBAAA+DejaVuSans
```


### Chinese, Japanese, Korean

When testing with these character sets, these are the fonts selected locally:

```bash
# Chinese
/FontName /QCBAAA+DroidSansFallback
# Japanese
/FontName /QFBAAA+DroidSansFallback
# Korean
/FontName /QGBAAA+DroidSansFallback
/FontName /QQBAAA+NanumGothic
```

I couldn't find a `DroidSansFallback` font package for CentOS and after some googling I found few fonts proposed in this [blog post](http://cnedelcu.blogspot.com/2015/04/wkhtmltopdf-chinese-character-support.html). I tried `WenQuanYiMicroHei` CentOS package `wqy-microhei-fonts` and after installing it `sudo yum install wqy-microhei-fonts` the problem was solved for these three character sets and now wkHTMLtoPDF selects the right font for each respectively:

```bash
# Chinese
/FontName /QKBAAA+WenQuanYiMicroHei
# Japanese
/FontName /QKBAAA+WenQuanYiMicroHei
# Korean
/FontName /QKBAAA+WenQuanYiMicroHei
```


### Other useful tools and notes

Lorem ipsum text in different languages useful for testing: [lipsum.com](http://www.lipsum.com/).

You might need to update the font cache after installing fonts (wasn't necessary in my case):

```bash
fc-cache -f -v
```
