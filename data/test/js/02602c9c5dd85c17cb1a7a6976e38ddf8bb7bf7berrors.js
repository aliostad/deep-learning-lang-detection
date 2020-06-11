module.exports.custom = function (res, code, message) {
  if (code === null) {
    code = 500;
  }
  if (message === null) {
    message = 'Internal Server Error';
  }
  res.send(code, message);
};

module.exports.badRequest = function (res, message) {
  if (message === null) {
    message = 'Bad Request';
  }
  res.send(400, message);
};

module.exports.unauthorized = function (res, message) {
  if (message === null) {
    message = 'Unauthorized';
  }
  res.send(401, message);
};

module.exports.forbidden = function (res, message) {
  if (message === null) {
    message = 'Forbidden';
  }
  res.send(403, message);
};

module.exports.notFound = function (res, message) {
  if (message === null) {
    message = 'Not found.';
  }
  res.send(404, message);
};

module.exports.badMethod = function (res, message) {
  if (message === null) {
    message = 'Method Not Allowed';
  }
  res.send(405, message);
};

module.exports.conflict = function (res, message) {
  if (message === null) {
    message = 'Conflict. File exists';
  }
  res.send(409, message);
};

module.exports.badInput = function (res, message) {
  if (message === null) {
    message = 'Unprocessable Entity. Bad Input.';
  }
  res.send(422, message);
};

module.exports.serverError = function (res, message) {
  if (message === null) {
    message = 'Internal Server Error';
  }
  res.send(500, message);
};