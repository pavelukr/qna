import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
    connected() {
        console.log('Connected to questions channel')
    },
    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
      $('.questions-index').append(data['question']);
    }
});
