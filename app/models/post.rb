class Post
  include MongoMapper::Document

  key :title,        String,  :required => true
  key :summary,      String,  :required => true
  key :body,         String
  key :tags,         String
  key :draft,        Boolean, :default => true
  key :category_ids, Array

  has_permalink :title
  has_textile :summary, :body

  many :categories, :in => :category_ids

  timestamps!

  def self.per_page; 10; end

  ##
  # For some reason mongomapper don't convert string into Mongo::ObjectID
  #
  def category_ids=(ids)
    categories = ids.map { |id| Category.find(id) rescue nil }.compact
    super(categories.map(&:id))
  end
end
