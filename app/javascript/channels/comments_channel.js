import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if(data.content[0].commentable_type === 'Question'){
      $('.comments_row_' + data.content[1].instance_id).append('<row>' + data.content[0].view + '</row>');
    }else {
      $('.comments-row-answers_' + data.content[1].instance_id).append('<row>' + data.content[0].view + '</row>');
    }

  }
});
