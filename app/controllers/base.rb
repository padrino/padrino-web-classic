PadrinoWeb.controllers :base do

  get :index, :map => "/" do
    render 'base/index'
  end

  get :team, :map => "/team" do
    @team = Account.all
    render 'base/team'
  end
end