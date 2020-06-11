# create Process 1 document
# [{"id":"5465656561486138aeb4dfc7","name":"Process 1"},{"id":"5465658261486138aeb4dfc8","name":"Process 2"},{"id":"5465658461486138aeb4dfc9","name":"Process 3"},{"id":"5465658661486138aeb4dfca","name":"Process 4"},{"id":"5465658961486138aeb4dfcb","name":"Process 5"}]

curl -H "Content-Type: application/json" \
  --data '[{"id":"5465656561486138aeb4dfc7","name":"Process 1"},{"id":"5465658261486138aeb4dfc8","name":"Process 2"},{"id":"5465658461486138aeb4dfc9","name":"Process 3"},{"id":"5465658661486138aeb4dfca","name":"Process 4"},{"id":"5465658961486138aeb4dfcb","name":"Process 5"}]' \
  http://localhost:8090/processDefinitions/upload
