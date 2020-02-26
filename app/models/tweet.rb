class Tweet < ApplicationRecord
    belongs_to :user
    has_many :tweet_tags
    has_many :tags, through: :tweet_tags

    #We only validate on create because of the way our create action works. Due to the line @tweet.save this will run a second db transaction which means it will again call link_check and apply_link
    # We do not want this because it will break our links   
    # Ex https://www.google.com/...'>href='https://www.googl...'>href='href='https://www...  
    validates :message, length: {maximum: 140, too_long: "A tweet is only 140 max. Everybody knows that!"}, on: :create
    #We use before_validation because a link alone can be more then 140 characters and our validation length specification above only allows for 140 chacters
    #This will make the link only 23 character so it can pass the validation 
    before_validation :link_check, on: :create 
    #We apply this after validation because technically speaking the creation of the hyperlink  is adding in more characters and we do not want  that to be counted in our validation process 
    after_validation :apply_link, on: :create 
    














private 


    def link_check
        # We need a variable that starts of at false so later on we can use it to check if that tweet message includes a link 
        check = false 
        if self.message.include?("http://")
            check = true 
        elsif self.message.include?("https://")
            check = true 
        else
            check = false 
        end
        #Now if check is equal to true then we know that the tweet includes a link 
        if check == true  
            #We split the tweet into an array of words 
            arr = self.message.split
            #We then go through all the words by using .map which returns a new array 
            # With the combination of word.include? we will get an array that returns true or false 
            #If "http" is found which means that word is a link 
            #We then call .index which return the first index with the arguement inside the ()
            #In this case the argument is true so this will find the first instance of true which returns an index of that link 
            index = arr.map{ |word| word.include? "http"}.index(true)
            #We then set the link attribute to arr[index] because arr[index] will give you the link
            #We do this to save the live link because the way this method is going to work is it is going to shorten the link for display purposes We got to make another method to make the link clickable
            self.link = arr[index]
            #We then check if the link is greater then 23 character
            if arr[index].length > 23 
                #If it is greater then 23 character we shorten it by adding a range so it will 23 character's max 
                arr[index] = "#{arr[index][0..22]}..."
            end 
            #After we are done with shortening the range we have to join the tweet arr back together to a string so we can assign it to the message 
            self.message = arr.join(" ")        
        end 
    end




    def apply_link 
        arr = self.message.split 
        index = arr.map{|word| word.include?("https") || word.include?("http")}.index(true)
        
        #If an index was found that means a link was found because index will hold the index position of the url
        # .index will either return something or nill and if it is nill the if statement won't run 
        if index
            #Right now arr[index] hold the shortened url or just the url if it is under 23 character long. This is because we applied the method link_check before it validates and that method shorten the url   
            shortened_url = arr[index]
            #We know that arr[index] holds the url so now we just turn that url into a clickable link 
            #We interpolate self.link inside the href and this was the reason was saved the link in our link_check method
            arr[index] = "<a href='#{self.link}'>#{shortened_url}</a>"
        end
        #We then have to set the self.message to the new specification that we wanted 
        # To do this we arr.join(" ") because arr right now is an array and we want to turn it back into a string
        self.message = arr.join(" ")
    end





end
