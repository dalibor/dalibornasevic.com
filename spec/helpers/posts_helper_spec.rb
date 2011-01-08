require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include PostsHelper

describe PostsHelper do

  it "should return tag name and class for 1 tag with count 1" do
    tag1 = mock_model(Tag, :count => '1', :name => 'tag1')
    tag_cloud([tag1], ['t1', 't2', 't3', 't4', 't5']) do |name, css_class|
      name.should == 'tag1'
      css_class.should == 't2'
    end
  end

  it "should return tag names and classes for 5 tags" do
    tag1 = mock_model(Tag, :count => '5', :name => 'tag1')
    tag2 = mock_model(Tag, :count => '10', :name => 'tag2')
    tag3 = mock_model(Tag, :count => '15', :name => 'tag3')
    tag4 = mock_model(Tag, :count => '20', :name => 'tag4')
    tag5 = mock_model(Tag, :count => '25', :name => 'tag5')

    tags = [tag1, tag2, tag3, tag4, tag5]
    classes = ['t1', 't2', 't3', 't4', 't5']
    index = -1
    tag_cloud(tags, classes) do |name, css_class|
      index += 1
      name.should == tags[index].name
      css_class.should == classes[index]
    end
  end

end
