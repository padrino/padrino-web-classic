class Category
  include MongoMapper::Document

  key :name, String, :required => true
  has_permalink :name

  def posts
    Post.all(:category_ids => id)
  end

  def post_count
    Post.count(:category_ids => id)
  end
end