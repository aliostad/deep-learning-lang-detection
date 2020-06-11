process "check_smth" do
  description "process checks smth"

  start_block "test_block_1"

  block "test_block_1" do
    action "bla::acc1", "acc1 description"
    endings(
      success: "test_block_2",
      failure: "process::failure"
    )
  end

  block "test_block_2" do
    action "bla::acc2", "acc2 description"
    endings(
      success: "process::success",
      failure: "process::failure"
    )
  end
end


process "test2" do
  description "process description"

  start_block "block_1"

  block "block_1" do
    reference_action "bla::acc1"
    endings(
      success: "process::success",
      failure: "process::failure"
    )
  end
end
