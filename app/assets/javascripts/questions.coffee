# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    console.log(question_id)
    $('form#edit-question-' + question_id).show();

  $('.question_vote .vote_up_link, .question_vote .vote_down_link').bind 'ajax:success', (e) ->
    response = e.detail[0];
    $('.question_vote .vote_value').html(response.vote.value);
    $('.question_vote .message').html('<p>' + response.message + '</p>');
    $('.question_vote .rating').html('<p>Rating: ' + response.rating + '</p>');
    $('.question_vote .existing_vote').show();
    $('.question_vote .new_vote').hide();

  $('.question_vote .vote_delete_link').bind 'ajax:success', (e) ->
    response = e.detail[0];
    $('.question_vote .message').html('');
    $('.question_vote .rating').html('<p>Rating: ' + response.rating + '</p>');
    $('.question_vote .existing_vote').hide();
    $('.question_vote .new_vote').show();
