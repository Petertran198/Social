class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  include TweetsHelper
  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    # You have to use Tweet.create instead of Tweet.new because you need @tweet to create the id to be able to use it wehn we connect the associaiton between tags and tweet through Tweet_tag. The association can be formed without an id from @tweet 
    @tweet = Tweet.create(tweet_params)
    We make a new array to hold each word of our tweet
    message_arr = Array.new 
    message_arr = @tweet.message.split 

    #This will parse through the indiviual words in that tweet 
    message_arr.each_with_index do |word,index|
      #If the first letter is a hashtag in the word 
      #We will either add it in our Tag model, or if it wasn't created yet we create a new instance of it 
      if word[0] == "#"
        #Pluck is a method that returns an array of attributes that matches the column's name 
        #With that being said we are looking if that array includes the word  
        #If it does then there is already a record of it in our database if not we will add it in 
        if Tag.pluck(:phrase).include?(word)
          tag = Tag.find_by(phrase: word)
        else  
          tag = Tag.create(phrase: word)
        end
        # So after we create a new instance of Tag or found it in the database we can use both tag and @tweet to set up the association by passing it into TweetTag 
        tweet_tag = TweetTag.create(tweet_id: @tweet.id, tag_id: tag.id)
        #message_arr[index] will return the word that includes the #hashtag, then we will change that #hashtag word into a link
        message_arr[index] = "<a href='/tag_tweets?id=#{tag.id}'>#{word}</a>"
      end
    end
    #After We are do with parsing through the tweet and checking if there is a #hashtag or not we then join the tweet back together because it was split and assign 
    @tweet.update(message: message_arr.join(" "))


    # get_tag(@tweet)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:message, :user_id)
    end
end
