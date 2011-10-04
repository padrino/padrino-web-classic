class PadrinoWeb < Padrino::Application
  register Padrino::Rendering
  register Padrino::Helpers
  register Padrino::Mailer
  register Padrino::Cache
  register Padrino::Contrib::ExceptionNotifier
  register Padrino::Contrib::Helpers::AssetsCompressor
  register Padrino::Contrib::Helpers::JQuery
  register Padrino::Contrib::Helpers::Flash

  set :caching, false
  set :exceptions_subject, "PadrinoWeb"
  set :exceptions_from,    "Padrino WebSite <exceptions@padrinorb.com>"
  set :exceptions_to,      Account.all.map(&:email)
  set :exceptions_page,    "base/errors"

  # Uncomment this for test in development
  # disable :raise_errors
  # disable :show_exceptions
end # PadrinoWeb
