ZimbraPasswordReset::Application.routes.draw do
  devise_for :users
  resources :users
  match "/mailboxes/search", :controller => "mailboxes", :action => "search"
  match "/mailboxes/reset_password", :controller => "mailboxes", :action => "reset_password"
  resources :mailboxes, :constraints => { :id => /.*/ }
  resources :password_resets
  root :to => "mailboxes#index"
end
