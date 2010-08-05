Admin.mailer :post do
  defaults :from => Admin.email_from

  email :added do |post|
    to Account.all.collect(&:email)
    subject "#{post.author.full_name} created a post #{post.title}"
    locals  :post => post
    render  "post/added"
  end

  email :edited do |post|
    to Account.all.collect(&:email)
    subject "#{post.author.full_name} edited a guide #{post.title}"
    content_type :html
    locals :post => post
    render "post/edited"
  end
end