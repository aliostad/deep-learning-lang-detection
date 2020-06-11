require "sinatra"

get "/" do
	"hello world!"
end

 get '/calc' do
 "
  <html>
    <body>
      <form action='/calculate' method='get'>
       number1:<input name='number1'/>
       number2:<input name='number2'/>
       <button type='submit' value='submit'/>
     </form>
    </body>body>
   </html>
  "
  end

  get '/calculate' do
    "Welcome to calculator"
   end

   get '/calculate' do
   	number1=rarans['number1'].to_i
   	number2=parans['number2'].to_i
   	sum=number1+number2

   	 "The sum of the numbers is#{sum}"
  end