require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_html'
require 'open-uri'

PadrinoWeb.controllers :base do

  get :index, :map => "/" do
    render 'base/index'
  end

  get :team, :map => "/team" do
    @team = Account.all(:order => "position", :team => true)
    @team_page = Page.find_labeled(:team)
    render 'base/team'
  end

  get :api, :map => "/api" do
    redirect "/api/index.html"
  end

  get :changes, :map => "/changes" do
    changes = Padrino.root("tmp/changelog-#{Time.now.strftime("%d%m%Y")}")
    unless File.exist?(changes)
      markup = SM::SimpleMarkup.new
      formatter = SM::ToHtml.new
      Dir[Padrino.root("tmp/changelog-*")].each { |f| File.delete(f) }
      rdoc = open("http://github.com/padrino/padrino-framework/raw/master/CHANGES.rdoc").read
      rdoc.gsub!(/= CHANGES\n\n/,'') # remove redundant <h1>CHANGES</h1>
      html = markup.convert(rdoc, formatter)
      html.sub!(/^<h2>/, '<h2 style="border-top:none">') # remove border from the first h2
      File.open(changes, "w") { |f| f.write html }
    end
    render :haml, "-title 'Changes'\n" + File.read(changes)
  end
end