Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :bookshelves do
    resources :bookshelf_items, only: [ :index, :new, :create, :show]
  end
  resources :books
end
