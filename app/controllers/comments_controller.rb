class CommentsController < ApplicationController 
    
    # EXTRA EXTRA EXTRA 
    def create 
       @tweet = Tweet.find(params[:tweet_id])
        @comment = @tweet.comments.new(comment_params)
        if @comment.save 
            redirect_to feed_path
        end
    end


    private 

    def comment_params 
        params.require(:comment).permit(:user_id, :post, :tweet_id)
    end

end