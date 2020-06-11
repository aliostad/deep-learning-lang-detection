require 'test_helper'

class ChunkTest < ActiveSupport::TestCase

  def test_invalid_with_empty_attributes
    
    puts "Testing invalid_with_empty_attributes\n"
    chunk = Chunk.new
    assert !chunk.valid?
    assert chunk.errors.invalid?(:client)
    assert chunk.errors.invalid?(:client_email)
    assert chunk.errors.invalid?(:author)
    assert chunk.errors.invalid?(:expire_date)
    assert chunk.errors.invalid?(:filename)
  end

  def test_argument_validation
        puts "Testing argument_validation\n"
    chunk = Chunk.new(:client => "I-D Media AG", :client_email => "falko@domain.de", :filename => "myfile.txt", :author => "falko.zurell@domain.com", :expire_date=> DateTime.now.to_date)
    assert chunk.valid?
  end

  def test_invalid_emails
    puts "Testing invalid_emails\n"
    evil_mails = ["falko.@", "falko_zurell@name", "falko@domain.d", "falko zurell@domain.de" , "falko@domain.v1", "falko@domain.names", "falko@domain_name.de" ]

    # create a valid new chunk
    chunk = Chunk.new(:client => "I-D Media AG", :client_email => "falko@domain.de", :filename => "myfile.txt", :author => "falko.zurell@domain.com", :expire_date=> DateTime.now.to_date)

    # this should be correct
    assert chunk.valid?

    # test the evil mails addresses against the client_email field
    evil_mails.each {|m|

      chunk.client_email = m
      assert_equal false, chunk.valid?, "Wrong client_mail  is #{m}\n"
     # assert_equal "Please enter a valid client mail address.", chunk.errors.on(:client_email), "Wrong is #{m}\n"

    }
    # test the evail mail addresses against the author field
    evil_mails.each {|m|
      chunk.author = m
      assert_equal false, chunk.valid?, "Wrong author is #{m}\n"
      # assert_equal "Please enter a valid eMail address for your email.", chunk.errors.on(:author), "Wrong is #{m}\n"

    }
    
    
  end
  
  def test_good_emails
    puts "Testing test_good_emails\n"
    good_mails = ["falko@domain.info", "falko.zurell@domain.com", "falko.zurellchunky@domain.com", "falko.zurell@sub.domain.com"]

    # create a valid new chunk
    chunk = Chunk.new(:client => "I-D Media AG", :client_email => "falko@domain.de", :filename => "myfile.txt", :author => "falko.zurell@domain.com", :expire_date=> DateTime.now.to_date)

    # this should be correct
    assert chunk.valid?
    
    # test good emails on client field
    good_mails.each {|m|
        chunk.client_email = m
        assert_equal true, chunk.valid?, "Wrong is #{m} \n"
      }
    
      # test good emails on author field
      good_mails.each {|m|
          chunk.author = m
          assert_equal true, chunk.valid?, "Wrong is #{m} \n"
        }
    
  end
  
  def test_expire_date
        puts "Testing expire_date\n"
    chunk = Chunk.new(:client => "I-D Media AG", :client_email => "falko@domain.de", :filename => "myfile.txt", :author => "falko.zurell@domain.com", :expire_date=> DateTime.now.to_date - 1)
    assert !chunk.valid?
    assert_equal "The expire date must be today or in future.", chunk.errors.on(:expire_date)
    
    chunk.expire_date = DateTime.now.to_date
    assert chunk.valid?
    
    chunk.expire_date = DateTime.now.to_date + 1
    assert chunk.valid?
    
  end
end
