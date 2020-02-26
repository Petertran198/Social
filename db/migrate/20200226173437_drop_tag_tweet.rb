class DropTagTweet < ActiveRecord::Migration[5.2]
  def change
    drop_table :tag_tweets
  end
end
