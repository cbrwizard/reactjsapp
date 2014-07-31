Rails.application.routes.draw do
  root 'literature#index'

  resources :books

  resources :authors do
    collection do
      get :get_books
    end
  end
end
