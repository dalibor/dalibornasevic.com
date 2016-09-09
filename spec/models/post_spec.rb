require 'spec_helper'

describe Post do

  describe ".all" do
    it "loads all files" do
      expect(Post.all.length).to eq(2)
    end

    it "loads post data attributes" do
      post = Post.all.first

      expect(post.id).to eq(1)
      expect(post.title).to eq('Post 1')
      expect(post.date).to eq(DateTime.parse('2015-02-05 10:00:00 +0200'))
      expect(post.author).to eq('Pink Panther')
      expect(post.tags).to eq(['tag1', 'tag2'])
      expect(post.image).to eq('/image.png')
      expect(post.summary).to eq('Post 1 summary')
    end

    it "converts markdown to html" do
      post = Post.all.first

      expect(post.content).to eq("<h1>Post 1</h1>\n\n<p><strong>Bold</strong></p>")
    end
  end

  describe ".find" do
    it "finds post by id" do
      post = Post.all.first

      expect(post).to be_present
      expect(Post.find(1)).to eq(post)
      expect(Post.find('1')).to eq(post)
      expect(Post.find('1-hello')).to eq(post)
    end
  end

  describe ".all_tags" do
    it "returns all tags sorted and uniq" do
      expect(Post.all_tags).to eq(['tag1', 'tag2', 'tag3'])
    end
  end

  describe "#to_param" do
    it "has readable url format using to_param method" do
      post = Post.new(id: 1, title: "My first blog post")
      expect(post.to_param).to eq("1-my-first-blog-post")
    end
  end
end
