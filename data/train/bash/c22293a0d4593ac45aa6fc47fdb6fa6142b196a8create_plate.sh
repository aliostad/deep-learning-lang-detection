curl -H 'Content-type:application/json' -H 'Accept:application/json' \
       	http://localhost:9292/plates \
	-d '{"plate" : {"number_of_rows":8, "number_of_columns":12, "wells_description":{
		"A12":[{"sample_uuid" :"11111111-0000-1111-0000-111111111111"}, {"sample_uuid"
		:"66666666-0000-1111-0000-111111111111"} ], "B11":[{"sample_uuid"
		:"22222222-0000-1111-0000-111111111111"}], "C10":[{"sample_uuid"
		:"33333333-0000-1111-0000-111111111111"}], "D9": [{"sample_uuid"
		:"44444444-0000-1111-0000-111111111111"}], "E8": [{"sample_uuid"
		:"55555555-0000-1111-0000-111111111111"}] }
}}'

