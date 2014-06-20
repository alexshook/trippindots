Rails.application.routes.draw do

    root to: 'dots#index'
    get '/echonest_analyze', to: 'dots#echonest_analyze'
    get '/search', to: 'dots#search'
    post '/upload', to: 'dots#upload'


end
