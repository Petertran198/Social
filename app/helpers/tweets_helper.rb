module TweetsHelper

    def get_tag(tweet)
        #Splitting the tweet into indiviual words
        message_arr = tweet.message.split
        #We parse through the tweet going through the individual words and added an index because we will use that index to find the word with the hashtag 
        message_arr.each_with_index do |word, index| 
            #If the first letter of that word is a hash then it is a hashtag 
            if word[0] == "#"
                #.pluck again returns an array and check if that array includes that word 
                #If the tag was found in the database we go look for it else if it wasn't found we create a new instance of it to save to the database 
                if Tag.pluck(:phrase).include?(word)
                    #We .downcase to check and save all the hashtags in lowercase 
                    tag = Tag.find_by(phrase: word.downcase)
                else
                    tag = Tag.create(phrase: word.downcase)
                end
                #After we made a new instace of Tag or find it in our database we can use both tag and tweet to set up the association or connect between tag and tweet by passing it into TweetTag 
                tweet_tag = TweetTag.create(tweet_id: tweet.id, tag_id: tag.id)
                message_arr[index] = "<a href='/tag_tweets?id=#{tag.id}'>#{word}</a>"
            end
        end
        #After we iterate through the whole tweet and found all the #hashtag we got to .join the tweet back because it was split
        #After that we assign it to tweet.tag 
        tweet.message = message_arr.join(" ")
        #Then we return tweet 
        return tweet
    end








end
