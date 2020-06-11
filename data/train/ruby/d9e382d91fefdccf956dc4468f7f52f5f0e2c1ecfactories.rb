FactoryGirl.define do
  factory :chunk, class: MyDataProcessors::Models::Chunk do
    id 'foo'
    date '2015-01-01'

    factory :visits_chunk do
      data('1' => [[1, 1], [1, 1]],
           '2' => [[1, 1], [1, 1]],
           '3' => [[1, 1], [1, 1]])
    end

    factory :spread_chunk do
      data('1' => {
             '79' => [15, 1],
             '80' => [10, 1],
             '85' => [10, 1]
           },
           '2' => {
             '79' => [15, 1],
             '80' => [10, 1],
             '85' => [10, 1]
           },
           '3' => {
             '79' => [15, 1],
             '80' => [10, 1],
             '85' => [10, 1]
           })
    end
  end
end
