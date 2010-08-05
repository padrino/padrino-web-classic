Admin.mailer :page do
  defaults :from => Admin.email_from

  email :added do |page|
    to Account.all.collect(&:email)
    subject "#{page.author.full_name} created a page #{page.title}"
    locals  :page => page
    render  "page/added"
  end

  email :edited do |page|
    to Account.all.collect(&:email)
    subject "#{page.author.full_name} edited a page #{page.title}"
    content_type :html
    locals :page => page
    render "page/edited"
  end
end