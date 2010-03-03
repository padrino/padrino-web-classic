=begin

Mailer methods can be defined using the simple format:

  def registration_email(name, user_email_address)
    from "admin@site.com"
    to user_email_address
    subject "Welcome to the site!"
    body    :name => name
    type    "html"                # optional, defaults to plain/text
    charset "windows-1252"        # optional, defaults to utf-8
    via     :sendmail             # optional, to smtp if defined otherwise sendmail
  end

=end

class Notifier < Padrino::Mailer::Base
  def self.base_url; "http://padrino.lipsiasoft.biz"; end
  
  def initialize(mail_name=nil)
    super(mail_name)
    @mail_attributes = { :from => "Padrino WebSite <noreply@padrinorb.com>" }
  end

  def registration(account)
    to account.email
    subject "Welcome to Padrino"
    body    :account => account
  end

  def guide_added(guide)
    to Account.all.collect(&:email)
    subject "#{guide.author.full_name} created a guide #{guide.title}"
    body    :guide => guide
  end

  def guide_edited(guide)
    to Account.all.collect(&:email)
    subject "#{guide.author.full_name} edited a guide #{guide.title}"
    body :guide => guide
    content_type "text/html"
  end

  def post_added(post)
    to Account.all.collect(&:email)
    subject "#{post.author.full_name} created a post #{post.title}"
    body    :post => post
  end

  def post_edited(post)
    to Account.all.collect(&:email)
    subject "#{post.author.full_name} edited a guide #{post.title}"
    body :post => post
    content_type "text/html"
  end

  def page_added(page)
    to Account.all.collect(&:email)
    subject "#{page.author.full_name} created a page #{page.title}"
    body    :page => page
  end

  def page_edited(page)
    to Account.all.collect(&:email)
    subject "#{page.author.full_name} edited a page #{page.title}"
    body :page => page
    content_type "text/html"
  end
end