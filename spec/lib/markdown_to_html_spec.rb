require 'spec_helper'

describe MarkdownToHTML do

  it "converts markdown to HTML" do
    expect(MarkdownToHTML.convert("**bold**")).to eq("<p><strong>bold</strong></p>")
  end

  it "highlights code" do
    expect(MarkdownToHTML.convert("```ruby\n puts 'a'\n```")).to eq(
      "<div class=\"highlight highlight-ruby\"><pre> <span class=\"nb\">puts</span> <span class=\"s1\">'a'</span>\n</pre></div>"
    )
  end
end
