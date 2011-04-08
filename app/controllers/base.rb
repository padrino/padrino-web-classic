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
    rdoc = open("https://github.com/padrino/padrino-framework/raw/master/CHANGES.rdoc").read
    rdoc.gsub!(/\= CHANGES\n\n/,'') # remove redundant <h1>CHANGES</h1>
    html = render :rdoc, rdoc
    html.sub!(/^<h2>/, '<h2 style="border-top:none">') # remove border from the first h2
    title "Changes"
    html.gsub!(/^/, "  ") # add two spaces before each line aka haml indentation
    render :haml, ":plain\n#{html}"
  end
end