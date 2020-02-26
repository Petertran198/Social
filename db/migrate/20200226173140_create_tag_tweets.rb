class CreateTagTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_tweets do |t|
      t.integer :tag_id
      t.integer :tweet_id

      t.timestamps
    end
  end
end
