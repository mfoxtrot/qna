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

  $('.answer_vote .vote_up_link, .answer_vote .vote_down_link').bind 'ajax:success', (e) ->
    response = e.detail[0];
    answer_id = response.vote.votable_id;
    console.log(answer_id)
    console.log(response.rating)
    $('.answer_vote .message[data-id=' + answer_id + ']').html('<p>' + response.message + '</p>');
    $('.answer_vote .existing_vote[data-id=' + answer_id + '] .vote_value').html('<p>' + response.vote.value + '</p>');
    $('.answer_vote .rating[data-id=' + answer_id + ']').html('<p>Rating: ' + response.rating + '</p>');
    $('.answer_vote .existing_vote[data-id=' + answer_id + ']').show();
    $('.answer_vote .new_vote[data-id=' + answer_id + ']').hide();

  $('.answer_vote .vote_delete_link').bind 'ajax:success', (e) ->
    response = e.detail[0];
    console.log(response.votable_id)
    $('.answer_vote .message[data-id=' + response.votable_id + ']').html('');
    $('.answer_vote .rating[data-id=' + response.votable_id + ']').html('<p>Rating: ' + response.rating + '</p>');
    $('.answer_vote .existing_vote[data-id=' + response.votable_id + ']').hide();
    $('.answer_vote .new_vote[data-id=' + response.votable_id + ']').show();

  $('.answer_comments .comment_form').bind 'ajax:success', (e) ->
    console.log e.detail
    response = e.detail[0];
    answer_id=response.comment.commentable_id
    block_to_add = JST["templates/comment"]({ comment: response.comment, author: response.author })
    $('.answer_comments[data-id=' + answer_id + '] .comments_list').append(block_to_add)
    $('.answer_comments[data-id=' + answer_id + '] textarea[name="answer[comment_body]"]').val('')


  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      console.log('connected!');
      question_id = $('.question').data('questionId');
      @perform 'follow', question_id: question_id
    ,

    received: (data) ->
      console.log data
      block_to_add = JST["templates/answer"]({answer: data.answer})
      $('.answers .answers_list').append(block_to_add)
    })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      listItems = $('.answers_list > li')
      subscribe = (item, obj) ->
        answerId = $(item).data('answerId')
        obj.perform 'follow', {commentable: 'answer', id: answerId}
        console.log answerId
      subscribe(item, @) for item in listItems
    ,

    received: (data) ->
      console.log data
      block_to_add = JST["templates/comment"]({ comment: data.comment, author: data.author });
      console.log block_to_add
      $('.answer_comments[data-id=' + data.comment.commentable_id + '] .comments_list').append(block_to_add)
    })
