class EpicenterController < ApplicationController
  def feed
    #This is what we will hold all our followers as well as our tweets 
    @following_tweets = [ ]
    #We then have to go through every tweet so we can check if the user is following that person then we show their post or if the post is ours then we show it as well
    Tweet.all.each do |tweet|
      if current_user.following.include?(tweet.user_id) ||
        current_user.id == tweet.user_id 
        @following_tweets.push(tweet)
      end
    end
    
  end


  def show_user
    #We have to set this,so  we can access this attribute in our view page 
    #Remember the controller passes data to the view, it has to set everything up so the view can actually display it
    #In addition .find doesn't care if it is a string or an Int it will still convert it for you EX.
    #Author.find(2) # => #<Author:1234>
    #Author.find("2") # => #<Author:1234>
    #Author.find("2") == Author.find(2)
    @user = User.find(params[:id])
  end

  def now_following
    #We are pushing the id of the show_user page because that is where 
    #We are implementing our following functionality
    # And the id we are pushing is id that belongs to that user 
    #This works because our .following is filled with ids of user that we follow 
    #The thing that is stored in params are always string and in this case we want to store integers because our user_id attribute is an integer 
    #In addition You have to push in an integer because on the show_user page it is searching for if current_user.following.include?(@user.id)  and @user.id is an int
    current_user.following.push(params[:id].to_i)
    #After we add it to our array we have to save it so the database can store it 
    current_user.save 
    redirect_to show_user_path(id: params[:id])

  end

  def unfollow
    #.delete is a method that we can use to delete an item if it is found within the ()
    current_user.following.delete(params[:id].to_i)
    current_user.save 
    redirect_to show_user_path(id: params[:id])

  end



  def tag_tweets 
    @tag = Tag.find(params[:id])
  end





end
