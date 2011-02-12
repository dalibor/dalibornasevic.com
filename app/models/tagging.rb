class Tagging < ActiveRecord::Base
  belongs_to :post
  belongs_to :tag
end

# == Schema Information
#
# Table name: taggings
#
#  id         :integer(4)      not null, primary key
#  post_id    :integer(4)
#  tag_id     :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

