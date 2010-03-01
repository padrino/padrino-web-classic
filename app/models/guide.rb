class Guide
  include MongoMapper::Document

  key :title,        String,  :required => true
  key :body,         String,  :required => true
  key :draft,        Boolean, :default => true

  has_permalink :title
  has_textile :body, :chapters => true, :internal_links => :guides

  timestamps!
end
