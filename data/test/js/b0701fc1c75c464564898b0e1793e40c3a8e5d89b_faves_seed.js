
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('favorites').del()
    .then(function () {
      // Inserts seed entries
      return Promise.all([
        knex('favorites').insert({
          show_id: 3
        }),
        knex('favorites').insert({
          show_id: 1
        }),
        knex('favorites').insert({
         show_id: 1
        }),
        knex('favorites').insert({
          show_id: 4
        }),
        knex('favorites').insert({
          show_id: 6
        }),
        knex('favorites').insert({
          show_id: 7
        }),
        knex('favorites').insert({
          show_id: 3
        }),
        knex('favorites').insert({
          show_id: 2
        })

      ])
    });
};
