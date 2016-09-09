require_dependency 'markdown_to_html'
require 'fileutils'

class Post
  include Virtus.model
  extend ActiveModel::Naming

  DATA_REGEX      = /\A(---\s*\n.*?\n?)^((---)\s*$\n?)/m
  POSTS_PATH      = File.join(Rails.root, 'posts')
  POSTS_CACHE_DIR = File.join(Rails.root, 'tmp', 'posts_cache')
  CACHING_ENABLED = !Rails.env.development?

  attribute :id, Integer
  attribute :title, String
  attribute :content, String
  attribute :date, DateTime
  attribute :author, String
  attribute :tags, Array
  attribute :image, String
  attribute :summary, String

  def to_param
    "#{id}-#{title.parameterize}"
  end

  class << self
    def all
      # Reset cache in development environment
      @all = nil unless CACHING_ENABLED
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

    def cache_all
      FileUtils.mkdir_p(POSTS_CACHE_DIR)

      each_post do |data, markdown, cache_path|
        File.write(cache_path, MarkdownToHTML.convert(markdown))
      end
    end

    private
    def load_all
      each_post do |data, markdown, cache_path|
        Post.new(
          id:       data.fetch('id'),
          title:    data.fetch('title'),
          date:     data.fetch('date'),
          author:   data.fetch('author'),
          tags:     data.fetch('tags'),
          content:  post_content(cache_path, markdown),
          image:    data.fetch('image', nil),
          summary:  data.fetch('summary')
        )
      end
    end

    def each_post
      Dir["#{POSTS_PATH}/*.md"].sort.map do |filename|
        source   = File.read(filename).match(DATA_REGEX)[0]
        markdown = $'.strip
        data     = YAML.load(source)
        cache_path = html_cache_path(filename)

        yield(data, markdown, cache_path)
      end
    end

    def html_cache_path(filename)
      File.join(POSTS_CACHE_DIR, filename.split('/').last.gsub('.md', '.html'))
    end

    def post_content(cache_path, markdown)
      if CACHING_ENABLED && File.exists?(cache_path)
        File.read(cache_path)
      else
        MarkdownToHTML.convert(markdown)
      end
    end
  end
end
