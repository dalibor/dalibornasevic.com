class Attachment < ActiveRecord::Base

  has_attached_file :attachment,
    :url => "/system/attachments/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/attachments/:id/:style/:basename.:extension"

  # Validations
  validates_presence_of :name, :editor_id
  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 5.megabytes

  # Associations
  belongs_to :editor
end
