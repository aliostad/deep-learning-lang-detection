require "test/unit"
require "crp"

class TestCRP < Test::Unit::TestCase

	def test_stop
		out = ""
		CRP.run do
			out << "Process"
			stop
		end
		assert_equal out, "Process"
	end

	def test_parallel
		out1 = ""
		out2 = ""
		CRP.run do
			process { out1 << "Process 1" }
			process { out2 << "Process 2"; stop }
		end
		assert_equal out1, "Process 1"
		assert_equal out2, "Process 2"
	end
	
	def test_sequence
		out = ""
		CRP.run do
			sequence do
				process { out << "Process 1\n" }
				process { out << "Process 2"; stop }			
			end
		end
		assert_equal out, "Process 1\nProcess 2"		
	end
	
	def test_process
		out = []
		CRP.process :test do |i|
			write "test", "Process #{i}"
		end
		CRP.run do
			channel "test"
			process :test, 1
			process :test, 2
			process { 2.times { out << read("test") }; stop }
		end
		assert_equal out, ["Process 1", "Process 2"]
	end
	
	def test_write_read
		out = ""
		CRP.run do
			channel "test"
			process { write "test", "From process 1" }
			process { msg = read "test"; out << msg; stop }
		end
		assert_equal out, "From process 1"
	end

	def test_read_write
		out = ""
		CRP.run do
			channel "test"
			process { msg = read "test"; out << msg; stop }
			process { write "test", "From process 1" }
		end
		assert_equal out, "From process 1"
	end
	
	def test_triple
		out = ""
		CRP.run do
			channel "a", "b"
			process { write "a", "From process 1" }			
			process { write "b", "From process 2" }
			process { msg1 = read("a"); msg2 = read("b"); out << "#{msg1} #{msg2}"; stop }			
		end
		assert_equal out, "From process 1 From process 2"
	end
	
	def test_skip
		out = ""
		CRP.run do
			process { skip; out << "Process"; stop }
		end
		assert_equal out, "Process"
	end
	
	def test_loop
		out = ""
		CRP.run do
			channel "test"
			process { 10.times { |i| write("test", i) }; stop }
			process { loop { out << read("test").to_s } }
		end
		assert_equal out, "0123456789"
	end
	
	def test_timeout
		out = 0
		CRP.run do
			process { out = timeout(0.1); stop }
		end
		assert out >= 0.1		
	end
	
end
