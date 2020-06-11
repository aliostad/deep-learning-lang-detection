
var Thread = function(root) {
  this.messages = []

  this.addMessage = function(message) {
    var child = null
    if (message.children) {
      child = message.children.shift()
    }

    if (message.children && message.children.length) {
      message.branching_threads = []
      message.children.forEach(function(child) {
        message.branching_threads.push(new Thread(child))
      })
    }

    delete message.children

    this.messages.push(message)

    if (child) {
      this.addMessage(child)
    }
  }

  this.addMessage(root)
}

module.exports = Thread
