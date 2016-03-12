require_dependency 'markdown_to_html'

class Post
  include Virtus.model
  extend ActiveModel::Naming

  DATA_REGEX = /\A(---\s*\n.*?\n?)^((---)\s*$\n?)/m
  POSTS_PATH = File.join(Rails.root, 'posts')

  attribute :id, Integer
  attribute :title, String
  attribute :content, String
  attribute :date, DateTime
  attribute :author, String
  attribute :tags, Array

  def to_param
    "#{id}-#{title.parameterize}"
  end

  class << self
    def all
      # Reset cache in development environment
      @all = nil if Rails.env.development?
      @all ||= load_all.sort_by(&:date)
    end

    def find(id)
      all.detect { |post| post.id == id.to_i }
    end

    def all_tags
      all.map(&:tags).flatten.uniq.sort
    end

    def by_year
      all.reverse.group_by { |post| post.date.year }
    end

    private
    def load_all
      Dir["#{POSTS_PATH}/*.md"].sort.map do |filename|
        data_string = File.read(filename).match(DATA_REGEX)[0]
        content     = $'.strip
        data        = YAML.load(data_string)

        Post.new(
          id: data['id'],
          title: data['title'],
          date: data['date'],
          author: data['author'],
          tags: data['tags'],
          content: MarkdownToHTML.convert(content)
        )
      end
    end
  end
end
