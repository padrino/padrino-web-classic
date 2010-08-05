class PadrinoWeb < Padrino::Application
  register Padrino::Helpers
  register Padrino::Mailer
  register Padrino::Contrib::ExceptionNotifier

  set :exceptions_subject, "PadrinoWeb"
  set :exceptions_from,    "Padrino WebSite <exceptions@padrinorb.com>"
  set :exceptions_to,      Account.all.map(&:email)
  set :exceptions_page,    "base/errors"
  # # Uncomment this for test in development
  # disable :raise_errors
  # disable :show_exceptions
end # PadrinoWeb