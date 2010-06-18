require 'md5'

class Account
  include MongoMapper::Document
  attr_accessor :password

  # Keys
  key :name,             String
  key :surname,          String
  key :email,            String
  key :crypted_password, String
  key :salt,             String
  key :role,             String
  key :description,      String
  key :home_page,        String
  key :team,             Boolean, :deafult => false
  key :position,         Integer, :default => 0

  # Validations
  validates_presence_of     :email, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save  :generate_password
  after_create :send_notification

  # Relations
  many :posts,  :foreign_key => "author_id", :dependent => :destroy
  many :guides, :foreign_key => "author_id", :dependent => :destroy
  many :pages,  :foreign_key => "author_id", :dependent => :destroy

  # Extensions
  has_textile :description

  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:email => email) if email.present?
    account && account.password_clean == password ? account : nil
  end

  ##
  # This method is used for retrive the original password.
  #
  def password_clean
    crypted_password.decrypt(salt)
  end

  ##
  # This method return name + surname
  #
  def full_name
    "#{name} #{surname}".strip
  end

  ##
  # This method return the gravatar
  #
  def gravatar(size=nil)
    hash = MD5::md5(email)
    gravatar  = "http://www.gravatar.com/avatar/#{hash}"
    gravatar += "?s=#{size}" if size.present?
    gravatar
  end

  ##
  # We need to prevent destroy if we have posts/guides/pages
  #
  def destroy
    posts.empty? && guides.empty? && pages.empty? ? super : false
  end

  private
    def generate_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = password.encrypt(self.salt)
    end

    def password_required
      crypted_password.blank? || !password.blank?
    end

    def send_notification
      Admin.deliver(:notifier, :registration, self)
    end
end