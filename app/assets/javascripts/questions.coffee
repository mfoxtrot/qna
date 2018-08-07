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

  $('.question_comments .comment_form').bind 'ajax:success', (e) ->
    console.log e.detail
    response = e.detail[0];
    block_to_add = JST["templates/comment"]({ comment: response.comment, author: response.author })
    $('.question_comments .comments_list').append(block_to_add)
    $('textarea[name="question[comment_body]"]').val('')

  $('.subscriptions').bind 'ajax:success', (e) ->
    console.log e.detail
    response = e.detail[0];
    $('.subscription_message').html('<p>' + response.message + '</p>');

    if (response.subscription_exists)
      link_label = 'Unsubscribe'
      $('.subscription_link').html('<a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="' + response.link + '">' + link_label + '</a>');
    else
      link_label = 'Subscribe'
      $('.subscription_link').html('<a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="' + response.link + '">' + link_label + '</a>');

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log('connected!');
      @perform 'follow'
    ,

    received: (data) ->
      user_id = $('.questions').data('userId');
      console.log data
      #json_data = JSON.parse(data);
      if (user_id == data.question.author_id)
        block_to_add = data.authors_template
      else
        block_to_add = JST["templates/question"]({ question: data.question });
      console.log block_to_add
      $('.questions').append(block_to_add)
    })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      console.log 'comments channel connected!'
      question_id = $('.question').data('questionId')
      console.log question_id
      @perform 'follow', {commentable: 'question', id: question_id}
    ,

    received: (data) ->
      console.log data
      block_to_add = JST["templates/comment"]({ comment: data.comment, author: data.author });
      console.log block_to_add
      $('.question_comments .comments_list').append(block_to_add)
      console.log $('.question_comments .comments_list')
    })
