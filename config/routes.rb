Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root 'literature#index'

  resources :books

  resources :authors do
    collection do
      get :get_books
    end
  end
end
