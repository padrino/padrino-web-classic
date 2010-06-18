Admin.mailer :notifier do
  defaults :form => Admin.email_from

  email :registration do |account|
    to account.email
    subject "Welcome to Padrino"
    locals  :account => account
    render  "notifier/registration"
  end
end