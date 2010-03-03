class PadrinoWeb < Padrino::Application
  ##
  # Exception Notifier
  # 
  register ExceptionNotifier
  set :exceptions_from, "Padrino WebSite <exceptions@padrinorb.com>"
  set :exceptions_to,   Account.all.map(&:email)
  set :exceptions_page, "base/errors"

  disable :padrino_mailer # disabled for a bug in padrino mailer in 0.9.3
end # PadrinoWeb