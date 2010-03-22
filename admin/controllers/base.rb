Admin.controllers :base do

  get :index, :map => "(/)" do
    render "base/index"
  end

  post :sort, :map => "/sort/:id" do
    return unless %w(guide page account).include?(params[:id])
    params[:ids].split(",").each_with_index do |id, position|
      klass = params[:id].classify.constantize
      klass.find(id).update_attributes(:position => position)
    end
  end
end