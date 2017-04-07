# README

<pre>

Task 1)   Local dev & deploy env.   

Create a fresh Rails 5.1 app, Ruby 2.4.1.   Include these gems:
	ActiveAdmin
	activeadmin-addons
	Enumerize
	Lograge
	pry-byebug (dev only, of course)
Create a model with a few fields, one of them enumerized.   
Write something in seed.rb to fill in 50-100 records.   
Configure AA access to it
Commit to a new Github repo.   
Deploy to a free-level Heroku server.   

Task 2)   System (aka integration) testing and AA mods.  

Read up on the Rails 5.1 incorporation of Capybara-Selenium-Chrome as default system-test framework, in Minitest.    We're trying to stick to that.  

Go test-first for these minor mods on your sample application:  
  a) limit index columns to just a few.    Exclude the id column.   
  b) make a new column (list view only)  that combines a string and the id, *and that value should link to the view page of the object*
	e.g.   "Thing Title (id 8)"    
  c) limit filters to just the enumerized field (pulldown),  and _contains search in a text field.  
  d) limit download links to just csv, and a second copy of the download link *above* the list.     
  e) similarly, add a second results count  up top.  
	This one should not include pagination links or counts.   Just "N matching #{model_plural}"  

Task 2.5)   generalize and test Enumerized field:  
	- make the gender values a class constant  Customer::VALID_GENDERS
	- add tests for enumerized field, as seen in that gem.   
	- add a single model test that checks for the gender constant values
		- then generalize the other tests to refer to the constant 
		- add an "unknown" value to the gender list, and see that only the model test breaks.

Task 2.6)  Enumerize test helper
	Enumerize is handy, and has n Rspec / shoulda helpers (see on github).       We're trying to stick to Minitest, so let's create something similar that shortens our tests.  

	- add a test helper like: 
	  test_enumerized(factory_symbol,  class_constant, desired_array, same_order_required = false)
		e.g.
	  test_enumerized(:customer,  Customer::VALID_GENDERS, %w(male female))

	it should also check that the constant (second param) matches the expected values.   Basically, just a helper form of my commit.  

	- add a customer field favorite_colors,  values from a constant again,   enumerized multiple: true   
	- expand helper to allow a multiple param, and add that check to the helper.   

	This pattern will come in handy for the next:

Task 3) Convert from fixtures to Factory Girl
	In the next set, you'll use PG specific types and serialization, so really need to run our test data through the model code.  

	- Add Factory Girl and convert your tests to use it.
	- add the model test and validation:    a new age field that should be between 18 and 99
		- model test should use the FG build method

We will definitely reuse this in the main code!  

Task 4) PG arrays

	- Read up on Postgres array values.     
	- convert favorite_colors to be stored as one.  Play around in SQL with storing and querying, so you'll be able to read ActiveRelation-generated SQL.   
	- write a system test expecting an active-admin pulldown filter for customers with that favorite color in that list.   
		- make it pass!  
	- write another test for an additional filter that lists the colors as a set of checkboxes, where customers colors match  *any* of the checked colors.  
	 	- make it pass!  
		
	Hint: ransackable scope.   
	This is directly relevant:   it is how we are storing the Data Problem flags on Carbon Records.  
	Next task will be on PG jsonb values, if you want to read ahead.  

</pre>
