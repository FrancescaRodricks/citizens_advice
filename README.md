# README
### How to setup the app and get started 
```sh
bundle install
rake db:create
rake db:migrate
rake db:seed
rspec spec --format documentation
rails s
```

```sh
rspec spec --format documentation

AuthTokenValidator
  #valid_token?
    when the token is not present
      should raise AuthTokenValidator::RequiredParamsValidationError
    when the token is present
      and it has not expired
        returns true
      and it has expired
        returns true
      and it cannot be decoded
        raises an error
  refresh_token
    when the token is more than 2 hours old
      raises an ExpiredToken error
    when the token is less that 2 hours old
      is exchanged for a fresh user token

Authentication
  authenticate
    when required params are present
      returns a user
    when username is not present
      raises RequiredParamsValidationError
    when password is not present
      raises RequiredParamsValidationError
  generate_token
    returns a JWT token

Api::V1::UsersController
  POST #register
    creates a new user
    when a user with the same email ID already exists
      returns http bad request
      returns an error message in the response
    when the params are all blank
      returns http bad request
      returns an error message in the response for all the fields

JsonWebToken
  .encode
    returns a token of length 105 characters
  .decode
    decodes the token and returns the correct user id

User
  is valid with valid attributes
  is not valid without an email
  when validating for unique email
    when no user exists with the same email
      is valid
    when a user exists with the same email
      is not valid

Finished in 0.19491 seconds (files took 1.74 seconds to load)
21 examples, 0 failures
```
```sh
User Registration 

curl -X POST \
  http://localhost:3001/api/v1/auth/register \
  -H 'Accept: application/hal+json,application/json' \
  -F email=john.doe@example.com \
  -F password=qwerty123 \
  -F username=john
```

```sh
User Refresh Token 
curl -X PUT \
  http://localhost:3001/api/v1/auth/refresh \
  -H 'Accept: application/hal+json,application/json' \
  -F token=eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2LCJleHAiOjE1NTk0MDYwNzJ9.a-NPvOA8x7kpa3i54AL7KLvvBRU-BYK8P1EBK0xrNY8
```

```sh
User authenticate with username and password

curl -X POST \
  http://localhost:3001/api/v1/auth/login \
  -H 'Accept: application/hal+json,application/json' \
  -F password=qwerty123 \
  -F username=john.doe
```

```sh
Create a new group

curl -X POST \
  http://localhost:3001/api/v1/groups \
  -H 'Accept: application/hal+json,application/json' \
  -H 'token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo2LCJleHAiOjE1NTk0MTEwMTV9.bbeHlvtO4mVi4Px474NlICd0XRkXr14b3qO9ptAcl9k' \
  -F password=test \
  -F username=test1 \
  -F 'name=test group 3'
```

### Not Attempted Tasks:
* Assign users to groups. 
* With a valid user token, other applications need to be able to supply a 
username or email address to request the user’s details (username, email 
address and group memberships). 

