# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bowler_session',
  :secret      => '7b32f5a7a0f2c96a2ea606630a932be84714df2bf524bcbd71b4b85c2ed9c7d156ddcc45d4e89dc4c89c5b95d258447da336ebaf6f414ed8bbf56d9a670e94fb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
