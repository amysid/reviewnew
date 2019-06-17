class Admin::AdminApplicationController < ActionController::Base
  include CommonConcern
  around_action :convert_flash, if: :check_flash
  layout 'admin_lte_2'
end
