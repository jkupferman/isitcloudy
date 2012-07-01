# Is It Cloudy?
### A dead simple way to check if a website is hosted on the cloud

I often found myself wondering if a given website was hosted on the cloud. After writing a script to do the whois lookup I decided why not create a simple webapp and let other peeople use it. Thus is it cloudy was born. 

Play with is it cloudy at:
http://isitcloudy.com

### What are some cloudy websites?
Check out these bad boys...
http://isitcloudy.com/q?url=http://www.heroku.com
http://isitcloudy.com/q?url=http://www.rightscale.com
http://isitcloudy.com/q?url=http://www.scobelizer.com

### How do I run this awesomesauce?
* Clone the git repo `git clone git://github.com/jkupferman/isitcloudy.git`
* Go in the directory `cd isitcloudy`
* Run bundler to install all the gems `bundle`
* Create the database `rake db:migrate`
* Run the rails server `script/server`
* Open up your browser and go to http://localhost:3000
