import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
    connected() {
        console.log('Connected to questions channel')
    },
    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        this.appendLine(data)
    },

    appendLine(data) {
        const html = this.createLine(data)
        const element = document.querySelector(".questions-index")
        element.insertAdjacentHTML("beforeend", html)
    },

    createLine(data) {
        return `
      <article class="chat-line">
        <span class="speaker">${data["content"]["title"]}</span>
        <span class="body">${data["content"]["body"]}</span>
      </article>
    `
    }
});
