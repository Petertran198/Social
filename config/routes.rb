Rails.application.routes.draw do
  resources :tweets
  devise_for :users
  root "epicenter#feed"

  get 'show_user' => 'epicenter#show_user'

  get 'now_following' => 'epicenter#now_following'

  get 'unfollow' => 'epicenter#unfollow'

  get 'tag_tweets' => 'epicenter#tag_tweets'


end
