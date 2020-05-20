// Turbolinks:load is just rails way of saying that fire the function after the page load 
// If you are familiar with Javascript document.ready() it is the same 
$(document).on("turbolinks:load", function(){
    // We then use jquery selector to grab the id #unfollow_btn 
    // and then use the hover function to change the class as well as text of our button 
    // hover takes two functions one for while u are hovering and one while u are not 
    // What we are trying to do is that when we hover on the button it says unfollow
    // it also changes the button to red by using bootstrap btn-danger 
    // and we are removing the default btn-primary class from the button 
    // when we let go of the hover it reverts back to the default button with Following 
    // and class of btn-primary
    $('#unfollow_btn').hover(function(){
        $(this).html("Unfollow");
        $(this).addClass('btn-danger');
        $(this).removeClass('btn-primary')
    }, function(){
        $(this).html("Following");
        $(this).removeClass('btn-danger');
        $(this).addClass('btn-primary');
    })
})