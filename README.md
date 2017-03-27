Fingerprint Code Test
=====================

First, I'd be happy to answer any questions about the code in this project. I tried to comment as appropriate in the code, and detail anything that didn't fit in the code below, but I'm sure I've forgotten/missed some things. 

Second, a random assortment of notes that didn't get placed as comments in the code.
  * I'm using the dotenv gem, but I haven't included the .env file. There are 6 keys defined: 
    MYSQL_USERNAME, MYSQL_PASSWORD, SEMANTICS_KEY, SEMANTICS_SECRET, ADMIN_PASSWORD, SALT. They should be pretty straightforward to replace, but I'm also happy to send the .env file if that would be easier.
    
  * I made the decision to not try to test/handle all variations of the Semantics API. For example, I noticed that they didn't accept Chinese characters as a search term. I'm sure there are a number of other error/edge cases that should be handled for the best user experience. Furthermore, there's a large amount of questionable data being returned - bad formatting of text, microscopic images, prices that don't match the link when you click through - but again, for the purposes of this exercise, I only completed a first pass. For example, I wrote the application for global support (UTC, UTF-8 in db), but I stuck with the default USD currency. 
  
  * I decided to go quick and simple with the admin functionality. In past Rails projects that need admins, I've created User model objects, used has_secure_password, created a separate AdminController that can act as a parent to any controllers that need to be behind the admin wall, created roles, and so on. I thought that would be overkill for this project, but I'd be happy to show you any past code.
  
  * Most of the tests use VCR to avoid making external calls. Long term, I would setup some re_record_intervals for the tests.
  
  * The email detailing the code test did specify that the project should display results in a table. I've assumed that a literal html table was not meant, and displayed the results in a format roughly inspired by Amazon. However, if indeed an actual table was required, let me know and I can adjust it. Overall, I spent very little time on any design elements (mostly because I don't have a lot of design skill to demonstrate). 
  
  * Regarding pagination, I thought about implementing infinite scroll, but decided that if Amazon and Google both do not, I shouldn't as well. In fact, it made me wonder if I should take out the infinite scroll in one of my other projects. 
  
Thanks for your time,
Evan
