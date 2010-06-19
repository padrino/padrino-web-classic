class Post
  include MongoMapper::Document

  key :title,        String,  :required => true
  key :summary,      String,  :required => true
  key :body,         String
  key :tags,         String
  key :draft,        Boolean, :default => true
  key :category_ids, Array
  key :author_id,    ObjectId, :required => true

  belongs_to :author, :class_name => "Account", :foreign_key => "author_id"
  many :categories, :in => :category_ids

  has_permalink :title
  has_textile   :summary, :body
  has_search    :title, :summary, :body

  timestamps!

  # Callbacks
  after_create :send_notification
  before_save  :send_notification_changes

  def self.per_page; 10; end

  ##
  # For unknow reasons "key :category_ids, Array,   :typecast => 'ObjectId'" didn't work
  #
  def category_ids=(ids)
    categories = ids.map { |id| Category.find(id) rescue nil }.compact
    super(categories.map(&:id))
  end

  private
    def send_notification
      Admin.deliver(:post, :added, self)
    end

    def send_notification_changes
      Admin.deliver(:post, :edited, self) if !new? && (title_changed? || summary_changed? || body_changed?)
    end
end
