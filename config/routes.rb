Rails.application.routes.draw do
 
  resources :categories
  devise_for :users
  
  resources :articles do
    resources :comments, only: [:create, :destroy, :update]
  end


  get 'welcome/index'
  get "special", to: "welcome#"
  root 'welcome#index'


=begin 
  resources articles:, except: [delete]
  resources articleS:, only: [:create, :show ] 

=end 

=begin
  get "/articles"   index
  post "/articles"  create
  delete "/articles"  delete

  get "/articles/:id"   show
  get "articles/new"   new
  get "articles/:id/edit"   edit
  patch "/articles/:id"   update
  put "/articles/:id"  update
=end
end
