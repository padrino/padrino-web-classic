xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title title("Blog")
    xml.link url(:base, :index)
    xml.description description
    xml.language "en-en"

    for post in @posts
      xml.item do
        xml.pubDate post.updated_at.rfc822
        xml.title post.title
        xml.link url(:blog, :show, :id => post)
        xml.guid post.id
        xml.description post.body_formatted
      end
    end
  end
end