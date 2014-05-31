Rails.application.routes.draw do

    root to: 'dots#index'
    get '/search', to: 'dots#search'


end
