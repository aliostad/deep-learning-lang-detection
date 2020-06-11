#pragma once

#ifndef SAMPLESTEST_HPP_
#define SAMPLESTEST_HPP_

#include "TestCase.hpp"

class SamplesTest : public TestCase
{
public:
  SamplesTest(CPS::Connection& connection);

protected:
  virtual void tear_down();
  virtual void run_tests();

private:
  void test_insert_sample();
  void test_update_sample();
  void test_replace_sample();
  void test_partial_replace_sample();
  void test_delete_sample();
  void test_search_sample();
  void test_aggregation_sample();
  void test_faceted_search_sample();
  void test_lookup_sample();
  void test_retrieve_sample();
  void test_list_last_sample();
  void test_list_paths_sample();
  void test_status_sample();
  void test_clear_sample();
  void test_reindex_sample();
};

#endif /* SAMPLESTEST_HPP_ */
