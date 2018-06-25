# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    console.log(answer_id)
    $('form#edit-answer-' + answer_id).show();

  $('.answer_vote .vote_up_link').bind 'ajax:success', (e) ->
    response = $.parseJSON(e.detail[2].responseText);
    answer_id = response.vote.votable_id;
    console.log(answer_id)
    console.log(response.rating)
    $('.answer_vote .message[data-id=' + answer_id + ']').html('<p>' + response.message + '</p>');
    $('.answer_vote .existing_vote[data-id=' + answer_id + '] .vote_value').html('<p>' + response.vote.value + '</p>');
    $('.answer_vote .rating[data-id=' + answer_id + ']').html('<p>Rating: ' + response.rating + '</p>');
    $('.answer_vote .existing_vote[data-id=' + answer_id + ']').show();
    $('.answer_vote .new_vote[data-id=' + answer_id + ']').hide();

  $('.answer_vote .vote_down_link').bind 'ajax:success', (e) ->
    response = $.parseJSON(e.detail[2].responseText);
    answer_id = response.vote.votable_id;
    console.log(answer_id)
    $('.answer_vote .message[data-id=' + answer_id + ']').html('<p>' + response.message + '</p>');
    $('.answer_vote .existing_vote[data-id=' + answer_id + '] .vote_value').html('<p>' + response.vote.value + '</p>');
    $('.answer_vote .rating[data-id=' + answer_id + ']').html('<p>Rating: ' + response.rating + '</p>');
    $('.answer_vote .existing_vote[data-id=' + answer_id + ']').show();
    $('.answer_vote .new_vote[data-id=' + answer_id + ']').hide();

  $('.answer_vote .vote_delete_link').bind 'ajax:success', (e) ->
    response = $.parseJSON(e.detail[2].responseText);
    console.log(response.votable_id)
    $('.answer_vote .message[data-id=' + response.votable_id + ']').html('');
    $('.answer_vote .rating[data-id=' + response.votable_id + ']').html('<p>Rating: ' + response.rating + '</p>');
    $('.answer_vote .existing_vote[data-id=' + response.votable_id + ']').hide();
    $('.answer_vote .new_vote[data-id=' + response.votable_id + ']').show();
