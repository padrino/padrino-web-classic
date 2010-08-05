Admin.mailer :guide do
  defaults :from => Admin.email_from

  email :added do |guide|
    to Account.all.collect(&:email)
    subject "#{guide.author.full_name} created a guide #{guide.title}"
    locals  :guide => guide
    render  "/guide/added"
  end

  email :edited do |guide|
    to Account.all.collect(&:email)
    subject "#{guide.author.full_name} edited a guide #{guide.title}"
    content_type :html
    locals :guide => guide
    render  "/guide/edited"
  end
end