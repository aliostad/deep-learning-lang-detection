package main

func buildRubyProject() {
	rubyGemfile(path + "/Gemfile")
	rubyRakefile(path + "/Rakefile")

	mkdir(path + "/lib")
	rubyMain(path + "/lib/" + nameSnakeCase + ".rb")

	mkdir(path + "/lib/" + nameSnakeCase)
	rubyStuff(path + "/lib/" + nameSnakeCase + "/stuff.rb")

	mkdir(path + "/test")
	rubyTest(path + "/test/test_stuff.rb")
}

func rubyGemfile(path string) {
	f := mkfile(path)
	writeLine(f, "source 'https://rubygems.org'")
	writeLine(f, "")
	writeLine(f, "gem 'rake'")
}

func rubyRakefile(path string) {
	f := mkfile(path)
	writeLine(f, "#!/usr/bin/env rake")
	writeLine(f, "")
	writeLine(f, "$LOAD_PATH << File.expand_path('../lib', __FILE__)")
	writeLine(f, "")
	writeLine(f, "require 'rake/testtask'")
	writeLine(f, "require '"+nameSnakeCase+"'")
	writeLine(f, "")
	writeLine(f, "task :run do")
	writeLine(f, "  "+nameCamelCase+".run")
	writeLine(f, "end")
	writeLine(f, "")
	writeLine(f, "Rake::TestTask.new do |t|")
	writeLine(f, "  t.libs << 'lib/"+nameSnakeCase+"'")
	writeLine(f, "  t.test_files = FileList['test/test_*.rb']")
	writeLine(f, "  t.verbose = true")
	writeLine(f, "end")
	writeLine(f, "")
	writeLine(f, "task :default => :test")
}

func rubyMain(path string) {
	f := mkfile(path)
	writeLine(f, "module "+nameCamelCase)
	writeLine(f, "  def self.run")
	writeLine(f, "    puts \"#{"+nameCamelCase+"::Stuff.hello}!\"")
	writeLine(f, "  end")
	writeLine(f, "end")
	writeLine(f, "")
	writeLine(f, "require '"+nameSnakeCase+"/stuff'")
}

func rubyStuff(path string) {
	f := mkfile(path)
	writeLine(f, "module "+nameCamelCase)
	writeLine(f, "  module Stuff")
	writeLine(f, "    def self.hello")
	writeLine(f, "      'Hello World'")
	writeLine(f, "    end")
	writeLine(f, "  end")
	writeLine(f, "end")
}

func rubyTest(path string) {
	f := mkfile(path)
	writeLine(f, "require 'minitest/autorun'")
	writeLine(f, "require 'minitest/pride'")
	writeLine(f, "require File.expand_path('../../lib/"+nameSnakeCase+".rb', __FILE__)")
	writeLine(f, "")
	writeLine(f, "class TestStuff < MiniTest::Unit::TestCase")
	writeLine(f, "")
	writeLine(f, "  def setup")
	writeLine(f, "    # before each test")
	writeLine(f, "  end")
	writeLine(f, "")
	writeLine(f, "  def teardown")
	writeLine(f, "    # after each test")
	writeLine(f, "  end")
	writeLine(f, "")
	writeLine(f, "  def test_hello")
	writeLine(f, "    assert 'Hello World' == "+nameCamelCase+"::Stuff.hello")
	writeLine(f, "  end")
	writeLine(f, "end")
}
