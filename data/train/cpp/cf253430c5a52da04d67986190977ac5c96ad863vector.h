#ifndef	VECTOR_H
#define VECTOR_H

class VectorUseSample
{
public:
	VectorUseSample();
	~VectorUseSample();
	void vector_constructor_sample();
	void vector_destructor_sample();
	void vector_assign_sample();
	void vector_at_sample();
	void vector_back_sample();
	void vector_begin_sample();
	void vector_capacity_sample();
	void vector_cbegin_sample();
	void vector_cend_sample();
	void vector_clear_sample();
	void vector_crbegin_sample();
	void vector_crend_sample();
	void vector_data_sample();
	void vector_emplace_sample();
	void vector_emplace_back_sample();
	void vector_empty_sample();
	void vector_end_sample();
	void vector_erase_sample();
	void vector_front_sample();
	void vector_get_allocator_sample();
	void vector_insert_sample();
	void vector_max_size_sample();
	void vector_operator_equal_sample();
	void vector_operator_brackets_sample();
	void vector_pop_back_sample();
	void vector_push_back_sample();
	void vector_rbegin_sample();
	void vector_rend_sample();
	void vector_reserve_sample();
	void vector_resize_sample();
	void vector_shrink_to_fit_sample();
	void vector_size_sample();
	void vector_swap_sample();
	void vector_relational_opeators();
	void vector_swap_vector_sample();

	void init();
protected:
private:
};

extern class VectorUseSample g_VectorTest;
#endif