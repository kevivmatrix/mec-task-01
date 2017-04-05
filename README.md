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

	This pattern will come in handy for the next:

Task 3) Convert from fixtures to Factory Girl
	In the next set, you'll use PG specific types and serialization, so really need to run our test data through the model code.  

	- Add Factory Girl and convert your tests to use it.
	- add the model test and validation:    a new age field that should be between 18 and 99
		- model test should use the FG build method

</pre>
