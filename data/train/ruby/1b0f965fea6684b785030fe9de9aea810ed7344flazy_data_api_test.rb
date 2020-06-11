require 'test_helper'

class LazyDataApiTest < ActiveSupport::TestCase
  test "should not be apiable by default" do
    assert !NoLazyDummy.apiable?
  end

  test "should be apiable" do
    assert LazyDummy.apiable?
  end

  test "should have api_id" do
    dummy = create :lazy_dummy

    assert_respond_to dummy, :api_id
  end

  test "should have default api_id" do
    dummy = create :lazy_dummy

    assert_not_nil dummy.api_id
  end

  test "should have specific api_id" do
    specific_api_id = 'specific_api_id'
    dummy = create :lazy_dummy, api_id: specific_api_id

    assert_equal dummy.api_id, specific_api_id
  end

  test "should find api_id" do
    dummy = create :lazy_dummy

    assert_equal dummy, LazyDummy.find_for_api(dummy.api_id)
  end

  test "should keep api_id" do
    dummy = create :lazy_dummy
    initial_api_id = dummy.api_id
    dummy.touch

    assert_equal dummy.api_id, initial_api_id
  end

  test "should keep api_id when create ids" do
    dummy = create :lazy_dummy
    initial_api_id = dummy.api_id
    LazyDummy.create_api_ids

    assert_equal dummy.api_id, initial_api_id
  end

  test "should create api_id when create ids" do
    dummy = create :lazy_dummy
    dummy.lazy_data_api_relation.destroy
    LazyDummy.create_api_ids

    assert_not_nil dummy.api_id
  end

  test "should create permanent api_id when create ids" do
    dummy = create :lazy_dummy
    dummy.lazy_data_api_relation.destroy
    LazyDummy.create_api_ids

    initial_api_id = dummy.reload.api_id
    assert_equal dummy.reload.api_id, initial_api_id
  end

  test "should remove api_id destroy" do
    dummy = create :lazy_dummy

    api_id = dummy.api_id
    dummy.destroy

    assert_nil LazyDataApi::Relation.where(api_id: api_id).first
  end

  test "should not create api_id if creation fails" do
    dummy = build :lazy_dummy, integer: 'a'
    dummy.save

    assert !dummy.valid?
    assert_not_nil dummy.api_id
    assert_nil LazyDataApi::Relation.where(api_id: dummy.api_id).first
  end
end
