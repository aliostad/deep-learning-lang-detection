import dispatch from 'aum-dispatch';

export default function (options) {
  dispatch('queue', options);

  options.data = options.data ? JSON.stringify(options.data) : '';

  options.onload = function (data) {
    var response = data ? JSON.parse(data) : null;

    options.defer.resolve(response);

    dispatch('queue', options);
  };

  options.onerror = function (data) {
    var response = data ? JSON.parse(data) : null;

    options.defer.reject(response);

    dispatch('queue', options);
  };

  dispatch('xhr', options);
}

