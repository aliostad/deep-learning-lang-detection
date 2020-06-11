//Create the admin user
            $pub = array(   'username' => ((!empty($save_info['publisher_url'])) ? $save_info['publisher_url'] : $request['publisher_url']),
                            'password' => $new_password,
                            'user-type' => 'PUBLISHER',
                            'email' => ((!empty($save_info['sender_email'])) ? $save_info['sender_email'] : $request['sender_email']),
                            'first-name' => ((!empty($save_info['company_name'])) ? $save_info['company_name'] : $request['company_name']),
                            'last-name' => 'Publisher',
                            'title' => 'NONE',
                            'language' =>  'en'
                         );
