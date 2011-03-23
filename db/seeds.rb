editor                       = Editor.find_or_create_by_email('dalibor.nasevic@gmail.com')
editor.name                  = 'Dalibor Nasevic'
editor.password              = 'password'
editor.password_confirmation = 'password'
editor.is_admin              = true
editor.save!
