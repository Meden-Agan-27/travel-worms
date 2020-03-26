Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get '/bookshelves/:id/bookshelf_items', to: 'bookshelf_items#index', as: 'bookshelf_items'
  resources :books do
    resources :reviews
  end

  resources :bookshelves do
    resources :bookshelf_items
  end
end
