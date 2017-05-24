Rails.application.routes.draw do
    root to: 'dots#index'
    get '/spotify_analyze', to: 'dots#spotify_analyze'
    get '/search', to: 'dots#search'
    post '/upload', to: 'dots#upload'
end
