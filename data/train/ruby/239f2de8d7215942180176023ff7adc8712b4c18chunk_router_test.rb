require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require '../lib/chunk_router'


class ChunkRouterTest < Minitest::Test

  def test_if_it_routes_hashes_to_the_hash_parser_class
    text = <<-EOS
## Chapter 1: The Beginning
    EOS

    chunk = ChunkRouter.new
    assert_equal :header, chunk.identify(text)
  end

  def test_if_it_routes_numbered_list_items_to_the_list_parser_class
    text = <<-EOS
1. Horror
2. Mystery
3. Documentary
    EOS

    chunk = ChunkRouter.new
    assert_equal :list, chunk.identify(text)
  end

  def test_if_it_routes_unordered_list_items_to_the_list_parser_class
    text = <<-EOS
* Sushi
* Barbeque
* Mexican
    EOS

    chunk = ChunkRouter.new
    assert_equal :list, chunk.identify(text)
  end

  def test_if_it_routes_links_with_no_extra_text_to_the_link_parser_class
    text = <<-EOS
[This link](http://example.net/)
    EOS

    chunk = ChunkRouter.new
    assert_equal :links, chunk.identify(text)
  end

  def test_if_it_routes_links_with_no_extra_text_to_the_link_parser_class
    text = <<-EOS
'You just *have* to try the *cheesecake,' **he said**.  Ever since* it appeared in
**Food & Wine** this place has been packed every night.  dumy dkeh skeh skehskdjdi
**dlksjdf**. asdkjfasldk.  *laksjdflksdjfm*, *laksjd*.
alskdjf. [This link](http://example.net/) **laksjdfalskdf**.
*lksjdf*.
    EOS

    chunk = ChunkRouter.new
    assert_equal :links, chunk.identify(text)
  end

  def test_if_it_routes_links_with_no_extra_text_to_the_link_parser_class
    text = <<-EOS
'You just *have* to try the *cheesecake,' **he said**.  Ever since* it appeared in
**Food & Wine** this place has been packed every night.  dumy dkeh skeh skehskdjdi
**dlksjdf**. asdkjfasldk.  *laksjdflksdjfm*, *laksjd*.
    EOS

    chunk = ChunkRouter.new
    assert_equal :paragraph, chunk.identify(text)
  end

end