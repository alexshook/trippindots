Rails.application.routes.draw do

    root to: 'dots#index'
    get '/search', to: 'dots#search'
    get '/search_soundcloud', to: 'dots#search_soundcloud'

end
