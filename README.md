# README

rspec spec --format documentation

Api::V1::UsersController
  POST #register
    creates a new user
    when a user with the same email ID already exists
      returns http bad request
      returns an error message in the response
    when the params are all blank
      returns http bad request
      returns an error message in the response for all the fields

User
  is valid with valid attributes
  is not valid without an email
  when validating for unique email
    when no user exists with the same email
      is valid
    when a user exists with the same email
      is not valid

Finished in 0.07481 seconds (files took 1.1 seconds to load)
9 examples, 0 failures

