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

Task 5) Learn Rails + jsonb  (also some Ransack and more AA)  
	Mainly, read up on it.     Learn the storage and query syntax in PG directly -- along the way, try out some inserts and queries directly in SQL.   Although Rails & Arel hide most of that, as usual, the syntax and operators are unusual.  When debugging, it helps to be able to read the SQL logs, to make sure Arel is doing what you intended.     Among the other things you can google:  https://www.postgresql.org/docs/9.4/static/datatype-json.html

	I'll phrase this one as a problem, not steps:  

	- Customer need contact info.   But there are a bunch of common ways:   mobile, landline, email, twitter, slack, facebook, etc.   
	- We'd like to allow a lot, but not waste a whole sparse column on each of them.    
	- We don't want an infinite list -- we don't need to store customers' Geocities handle :-) -- so limit to a chosen list of 10-15.   
		- note in the code how to add or remove a standard contact type.    
	- Allow editing,searching, and displaying int the app.  
	   - displaying should include showing all contacts in list view.    Probably in one column, since 10-15 mostly empty columns is lame.  
	   - Searching should include
		- a text box for searching across all values, i.e. "one of their contacts contains 'vivek'"  
		- a way to filter having certain contact types:   "show only customers that have a facebook and an email"   
	- Note in the code how to add or remove a standard contact type.   

	And of course, tests to prove that!  

	Hints:  ransackable scopes.   jsonb_accessor gem could be useful, depending on choices.   

	Code relevance:    we store several things as jsonb, including the important raw data that comes from the partners.     I also use it for result recording and other feedback / messages.   I have placeholders for more, as I anticipate needing it for various particular carbon-calculation parameters, per product or partner.

	Good work on the task 5 cleanup.    My only comments would be minor style questions, so I'll skip right over them here, and make sure we keep you moving.     

As you've heard on the calls, reports are coming up.   Let's get you there.     This is a sizable one, and much more like a full coding problem.   

Task 6)  Async Reporting 

	a)  Simple exporting.

	Problem:    Our admin users want to export the whole list pretty often.    Customers, in (imaginary) production use, are so numerous that foreground AA exporting is taking too long.  It needs to go in the background.   Looking ahead, we need to get away from AA export anyhow, to do more interesting reporting.    

	Use Case:   Admin users should be able to trigger a full export of all customers that runs in the background.   "Full" meaning all fields, including the contact types.     When it's done, they would like to have that export findable on the site, and be able to share a link to it, rather than handing the full file around on email.     

	Suggestion:  That use case suggests a model with an attached file.   After creation, it could send its job to the queue, but otherwise can be managed by AA. 

	Tech limitations:     For consistency with other code, use Carrierwave for attachements, and S3 for storage, at least on production.   (Dev storage is your choice -- I'm fine with S3 even locally, for consistency)        Heroku doesn't offer Redis yet in its Indian regional deploys, so use Delayed::Job w/ AR storage.      (Also, this is a low-volume queue, so the DB penalty of DJ is insignificant)  

	This will need to get deployed to Heroku, which will be another step

	On S3, use a bucket I just made called
	 htllc-mec-vivek

	I made an IAM user with access.   The access key is at the bottom of this email.    The secret I will skype you, for a modicum of security.    Remember not to post the keys to github.


	Looking ahead on the next parts, in case it informs your design:  
	6b)  will be making generalizing:   a couple other varieties of reports, that do some calculations for different output
	6c)  will be adding the ability to accept ransack query params to limit the reporting.   

Task 7)  Filtered reporting
	As touched on earlier.

	Use case:     The users wish to report on filtered search results.      (For BasicCustomer, this isn't very different from the built-in export, but is more useful for other types)

	Add a way to do trigger a new report generation, from the Customer index page, that limits the reporting to the filter results.    Passing the ransack filters is OK -- we do not need to pass exact id list or such.   


Task 8)  More reports

	Add two reports:  
	a)  Color analysis:   
	  For each color,
	   -  # of customers with that favorite
	   -  # of customers who have only that color as favorite. 
	   -  average # of colors per customer
	   - average # of customers per color

	b)  contact + age analysis
	    For each contact type,
		- count of customers with that contact type
		- min, max and average age of those customers

	Those should be runnable from the reports page.   When task 7 is done, they should also accept filtering restriction.   

</pre>
