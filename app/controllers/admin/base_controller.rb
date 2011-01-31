class Admin::BaseController < ApplicationController

  before_filter :authenticate
  layout "admin"
end
