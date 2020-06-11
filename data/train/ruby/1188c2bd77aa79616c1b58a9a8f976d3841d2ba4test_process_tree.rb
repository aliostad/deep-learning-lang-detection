require "test/unit"
require "mswin-build/process_tree"

class TestProcessTree < Test::Unit::TestCase
  def setup
    @makefile = "Makefile"
    open(@makefile, "w") do |f|
      f.puts <<-EOM
all:
	@ruby -e "Process.waitpid Process.spawn('ruby -e \"sleep\"')"
      EOM
    end
  end

  def teardown
    File.delete(@makefile) if File.exist?(@makefile)
  end

  def test_s_terminate_process_tree
    pid = Process.spawn("nmake -l")
    sleep 1

    assert_nil Process.waitpid(pid, Process::WNOHANG)
    assert_equal 3, MswinBuild::ProcessTree.terminate_process_tree(pid)
  end
end if /mswin|mingw/ =~ RUBY_PLATFORM
