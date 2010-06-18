class Page
  include MongoMapper::Document
  attr_accessor :label_name

  key :title,        String,   :required => true
  key :body,         String,   :required => true
  key :draft,        Boolean,  :default => true
  key :author_id,    ObjectId, :required => true
  key :label_id,     ObjectId
  key :position,     Integer, :default => 0

  belongs_to :author, :class_name => "Account",   :foreign_key => "author_id"
  belongs_to :label,  :class_name => "PageLabel", :foreign_key => "label_id"

  has_permalink :title
  has_textile   :body,  :chapters => true, :internal_links => :pages
  has_search    :title, :body

  timestamps!

  # Callbacks
  before_save  :generate_label
  after_create :send_notification
  before_save  :send_notification_changes
  validate     :label_present

  def self.per_page; 10; end

  def self.find_labeled(name)
    label = PageLabel.first("$where" => "this.name.match(/#{name.to_s.humanize}/i)")
    first(:label_id => label.id, :draft => false) if label
  end

  def self.find_all_labeled(name)
    label = PageLabel.first("$where" => "this.name.match(/#{name.to_s.humanize}/i)")
    label ? all(:label_id => label.id, :draft => false, :order => "position") : []
  end

  private
    def label_present
      errors.add(:label, "must be present") if label_id.blank? &&  label_name.blank?
    end

    def generate_label
      return if label_name.blank?
      self.label_id = PageLabel.find_or_create_by_name(label_name).try(:id)
    end

    def send_notification
      Admin.deliver(:page, :added, self)
    end

    def send_notification_changes
      Admin.deliver(:page, :edited, self) if !new? && (title_changed? || body_changed?)
    end
end

class PageLabel
  include MongoMapper::Document
  key :name, :required => true, :unique => true
  key :description, String

  many :pages, :foreign_key => :label_id

  ##
  # We need to prevent destroy
  #
  def destroy
    pages.empty? ? super : false
  end
end
