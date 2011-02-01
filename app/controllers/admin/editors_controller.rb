class Admin::EditorsController < Admin::BaseController
  before_filter :require_admin

  inherit_resources

end
