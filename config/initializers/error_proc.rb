#module ActionView
#  class Base
#    @@field_error_proc = Proc.new { |html_tag, instance| 
#      "<div class=\"fieldWithErrors\">#{html_tag}</div>"
#    }
#    cattr_accessor :field_error_proc
#  end
#
#end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    html_tag
end
