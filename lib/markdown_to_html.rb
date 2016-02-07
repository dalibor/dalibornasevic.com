require 'github/markup'
require 'html/pipeline'

class MarkdownToHTML

  def self.convert(content)
    html = GitHub::Markup.render('', content)
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SyntaxHighlightFilter
    ]

    result = pipeline.call(html)
    return result[:output].to_s
  end
end
