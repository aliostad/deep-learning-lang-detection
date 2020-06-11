module.exports = function() {

  this.hey = function(message) {
    response = 'Whatever.'
    if(is_empty(message)) {
      response = "Fine. Be that way!"
    } else if(is_uppercase(message)) {
      response = 'Woah, chill out!'
    } else if(is_quest(message)) {
      response = 'Sure.'
    }
    return response
  }
}

is_empty = function(message) {
  return message.trim() == ""
}

is_uppercase = function(message) {
  return message == message.toUpperCase()
}

is_quest = function(message) {
  return message.charAt(message.length - 1) == '?'
}
