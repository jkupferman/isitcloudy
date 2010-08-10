# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cloud_checker_session',
  :secret      => 'c529ca6a3591fa67632bdcde6a5353cdadb1d92dfe90e367de6eeecb7477f1218f6d95433051f7dbbceb6573d3ea3707dc73e46ce1863508881d9d07d968e9c5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
