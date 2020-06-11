const MessageStore = require('./message_store');

module.exports = {
  renderMessage(message) {
    let messageEl = document.createElement("li");
    messageEl.className = "message";
    messageEl.innerHTML = `
    <span class="from">To: ${message.to}</span>
    <span class="subject">${message.subject}</span> -
    <span class="body">${message.body}
    `;
    return messageEl;
  },
  render() {
    let container = document.createElement("ul");
    container.className = "messages";
    let messages = MessageStore.getSentMessages();
    messages.forEach(message => {
      container.appendChild(this.renderMessage(message));
    });
    return container;
  }
};
