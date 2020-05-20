class EpicenterController < ApplicationController
  require 'will_paginate/array' ##This is required to set up pagination for an array 


  def feed
    #This is what we will hold all our followers as well as our tweets 
    @following_tweets = []
    #This will show us the tweets that are created first
    @tweets = Tweet.order('created_at DESC')
    #We then have to go through every tweet so we can check if the user is following that person then we show their post or if the post is ours then we show it as well
    @tweets.each do |tweet|
      if current_user.following.include?(tweet.user_id) ||
        current_user.id == tweet.user_id 
        @following_tweets.push(tweet)
      end
    end

    # EXTRA EXTRA EXTRA 
    #The will paginate gem comes with a method called .paginate(page: params[:page])
    # With this method we can paginate our page but we also can add an option of how many page we want it to paginate too
    @following_tweets = @following_tweets.paginate(page: params[:page], per_page: 3)
    #We added this because in order to make a comment on a page we will need to initalize a  new @comment instance varaible as well as associated it with a tweet.id 
    @comment = Comment.new 
    
  end


  def show_user
    #We have to set this,so  we can access this attribute in our view page 
    #Remember the controller passes data to the view, it has to set everything up so the view can actually display it
    #In addition .find doesn't care if it is a string or an Int it will still convert it for you EX.
    #Author.find(2) # => #<Author:1234>
    #Author.find("2") # => #<Author:1234>
    #Author.find("2") == Author.find(2)
    @user = User.find(params[:id])
    @tweets = @user.tweets.paginate(page: params[:page], per_page: 3)

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


  #This is to give us all the tweets of a certain tag 
  def tag_tweets 
    @tag = Tag.find(params[:id])
  end


  #All_users will show us all the users 
  def all_users
    @users = User.all
  end

  #Followings are going to show us the followings of a certain user
  def followings 
    @user = User.find(params[:id])
    @users = []
    #The @user is the owner of the page. For example Mark's Instagram he will be the @user and we are trying to see his followers and followings 
    #We first iterate through all our users then if @user(Mark)'s  following array includes the id of the person we are iterating through. If it does then it must be that @user(Mark) is following that person
    User.all.each do |person|
      if @user.following.include?(person.id)
          @users.push(person)
      end
    end
  end

  #Followers are going to show us the followers of a certain user
  #The @user is again the owner of the page. We will still use Mark He will be the @user.
  # We  then iterate through all the users and see if they have @user or aka mark's id in their following array 
  def followers 
    @user = User.find(params[:id])
    @users = []
    User.all.each do |person| 
      if person.following.include?(@user.id)
        @users.push(person)
      end
    end
  end

end
