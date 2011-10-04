class Admin < Padrino::Application
  register Padrino::Rendering
  register Padrino::Helpers
  register Padrino::Mailer
  register Padrino::Admin::AccessControl
  register Padrino::Contrib::Helpers::JQuery
  register Padrino::Contrib::Helpers::Flash

  # App setting
  set :email_from, "Padrino WebSite <noreply@padrinorb.com>"
  set :domain,     "http://www.padrinorb.com"

  # Authentication
  enable  :authentication
  disable :store_location
  set :login_page, "/admin/sessions/new"

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  access_control.roles_for :admin do |role, account|
    role.allow "/page_labels"
    role.allow "/categories"
    role.project_module :pages, "/pages"
    role.project_module :guides, "/guides"
    role.project_module :posts, "/posts"
    role.project_module :accounts, "/accounts"
  end
end
