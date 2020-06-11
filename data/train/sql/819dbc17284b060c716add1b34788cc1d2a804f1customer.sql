<?xml version="1.0"?>
<query>
    <select>customer.code as "Customer Code", customer.name as "Customer Name", customer.phone as "Customer Phone", customer.address as "Customer Address", customer.age as "Customer Age", customer.photo as "Customer Photo", customer.ref_city as "Customer City Code", city.description as "City Description", state.code as "State Code", state.description as "State Description"</select>
    <from>customer,city,state</from>
    <where>city.ref_state = state.code and customer.ref_city = city.code</where>
    <groupby></groupby>
    <orderby>customer.name asc</orderby>
</query>