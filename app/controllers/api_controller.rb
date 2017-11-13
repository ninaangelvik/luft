class ApiController < ActionController::Metal
 include AbstractController::Rendering
 include ActionView::Layouts
  append_view_path "#{Rails.root}/app/views"
end
