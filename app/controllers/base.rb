require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_html'
require 'open-uri'

PadrinoWeb.controllers :base, :cache => true do

  get :index, :map => "/" do
    render 'base/index'
  end

  get :team, :map => "/team" do
    @team = Account.all(:order => "position", :team => true)
    @team_page = Page.find_labeled(:team)
    render 'base/team'
  end

  get :api, :map => "/api", :cache => false do
    redirect "/api/index.html"
  end

  get :changes, :map => "/changes" do
    expires_in 3600
    logger.debug "Getting Change Log"
    markup = SM::SimpleMarkup.new
    formatter = SM::ToHtml.new
    rdoc = open("https://github.com/padrino/padrino-framework/raw/master/CHANGES.rdoc").read
    rdoc.gsub!(/\= CHANGES\n\n/,'') # remove redundant <h1>CHANGES</h1>
    html = markup.convert(rdoc, formatter)
    html.sub!(/^<h2>/, '<h2 style="border-top:none">') # remove border from the first h2
    html.gsub!(/^/, "  ") # add two spaces before each line aka haml indentation
    settings.cache.set(:changes, html)
    render :haml, "- title 'Changes'\n:plain\n#{settings.cache.get(:changes)}"
  end
end