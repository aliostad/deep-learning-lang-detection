# -*- coding: utf-8 -*-
require 'spec_helper'

describe Gcal::Calculate::Format do
  let(:event)   { {"desc" => "ピラメキーノ" } }
  let(:events)  { [event] }
  let(:format)  { nil }

  let(:data) { execute }

  def build_options
    {
      :format => format,
      :events => events,
    }.delete_if{|(k,v)| v.nil?}
  end

  def execute
    receiver  = Gcal::Common::Variables.execute.receiver
    calculate = Gcal::Calculate::Format.new

    receiver.data.merge!(build_options)
    calculate.receiver = receiver
    calculate.execute
    return calculate.data
  end

  def desc
    events = data[:events].must(Array)
    event  = events.first.must(Hash)
    event["desc"]
  end

  context "(default)" do
    let(:format)  { nil }

    specify "return itself" do
      desc.should == "ピラメキーノ"
    end
  end

  context '("[も] %s")' do
    let(:format)  { "[も] %s" }

    specify "return '[も] ' prefixed" do
      desc.should == "[も] ピラメキーノ"
    end
  end
end
