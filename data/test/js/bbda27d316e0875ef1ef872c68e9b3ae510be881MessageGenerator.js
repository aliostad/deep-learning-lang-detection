var MidiMessage                 = require('./Message/MidiMessage'),
    NoteOffMessage              = require('./Message/NoteOffMessage'),
    NoteOnMessage               = require('./Message/NoteOnMessage'),
    PolyphonicAftertouchMessage = require('./Message/PolyphonicAftertouchMessage'),
    ControlChangeMessage        = require('./Message/ControlChangeMessage'),
    ProgramChangeMessage        = require('./Message/ProgramChangeMessage'),
    ChannelAftertouchMessage    = require('./Message/ChannelAftertouchMessage'),
    PitchBendMessage            = require('./Message/PitchBendMessage'),
    SystemExclusiveMessage      = require('./Message/SystemExclusiveMessage'),
    QuarterFrameMessage         = require('./Message/QuarterFrameMessage'),
    SongPositionMessage         = require('./Message/SongPositionMessage'),
    SongSelectMessage           = require('./Message/SongSelectMessage'),
    SystemMessage               = require('./Message/SystemMessage'),
  
    Readable                    = require('stream').Readable,
    util                        = require('util')

  ;

var MessageGenerator = module.exports = function MessageGenerator() {
    Readable.call(this, {objectMode: true});
};

util.inherits(MessageGenerator, Readable);

MessageGenerator.prototype._pushMessage = function(message) {
  this.push(message.toBuffer());
  this.emit('message', message);
  return message;
};

MessageGenerator.prototype._read = function() {
  this.readable = true;
};

MessageGenerator.prototype.noteOff = function(channel, note) {
  return this._pushMessage(new NoteOffMessage(channel, note));
};

MessageGenerator.prototype.noteOn = function(channel, note, velocity) {
  return this._pushMessage(new NoteOnMessage(channel, note, velocity));
};

MessageGenerator.prototype.polyphonicAftertouch = function(channel, note, pressure) {
  return this._pushMessage(new PolyphonicAftertouchMessage(channel, note, pressure));
};

MessageGenerator.prototype.controlChange = function(channel, control, value) {
  return this._pushMessage(new ControlChangeMessage(channel, control, value));
};

MessageGenerator.prototype.programChange = function(channel, program) {
  return this._pushMessage(new ProgramChangeMessage(channel, program));
};

MessageGenerator.prototype.channelAftertouch = function(channel, pressure) {
  return this._pushMessage(new ChannelAftertouchMessage(channel, pressure));
};

MessageGenerator.prototype.pitchBend = function(channel, pitch) {
  return this._pushMessage(new PitchBendMessage(channel, pitch));
};

MessageGenerator.prototype.systemExclusive = function(manufacturerId, deviceId, data) {
  return this._pushMessage(new SystemExclusiveMessage(manufacturerId, deviceId, data));
};

MessageGenerator.prototype.quarterFrame = function(data) {
  return this._pushMessage(new QuarterFrameMessage(data));
};

MessageGenerator.prototype.songPosition = function(position) {
  return this._pushMessage(new SongPositionMessage(position));
};

MessageGenerator.prototype.songSelect = function(song) {
  return this._pushMessage(new SongSelectMessage(song));
};

MessageGenerator.prototype.tuneRequest = function() {
  return this._pushMessage(new SystemMessage(0xf6));
};

MessageGenerator.prototype.clock = function() {
  return this._pushMessage(new SystemMessage(0xf8));
};

MessageGenerator.prototype.start = function() {
  return this._pushMessage(new SystemMessage(0xfa));
};

MessageGenerator.prototype.continue = function() {
  return this._pushMessage(new SystemMessage(0xfb));
};

MessageGenerator.prototype.stop = function() {
  return this._pushMessage(new SystemMessage(0xfc));
};

MessageGenerator.prototype.activeSensing = function() {
  return this._pushMessage(new SystemMessage(0xfe));
};

MessageGenerator.prototype.reset = function() {
  return this._pushMessage(new SystemMessage(0xff));
};


