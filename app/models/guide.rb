class Guide

  include MongoMapper::Document

  key :title,        String,  :required => true
  key :body,         String,  :required => true
  key :draft,        Boolean, :default => true
  key :category_ids, Array
  key :author_id,    ObjectId, :required => true
  key :position,     Integer, :default => 0

  belongs_to :author, :class_name => "Account", :foreign_key => "author_id"

  has_permalink :title
  has_textile   :body,  :chapters => true, :internal_links => :guides
  has_search    :title, :body

  timestamps!

  # Callbacks
  after_create :send_notification
  before_save  :send_notification_changes

  def self.per_page; 10; end

  private
    def send_notification
      Admin.deliver(:guide, :added, self)
    end

    def send_notification_changes
      Admin.deliver(:guide, :edited, self) if !new? && (title_changed? || body_changed?)
    end
end
