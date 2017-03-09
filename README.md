# renton

A very simple blog application developed using Ruby on Rails, HTML & CSS.


## Requirements
- Ruby version: 2.1.5
- Rails version: 4.2.2
- Some components like forms and buttons require HTML5 & CSS3 support.

## Run it! (development environment)

Execute the following command to start the web server on your machine:

`renton$ bin/rails server`

Then, go to the given HTTP address (default is http://localhost:3000).

#### Admins

You can manage the administrators and the users of this blog using `lib/users_management.rb`
- Add a new user/admin: `renton$ bin/rails r lib/users/users_management.rb add`
- Delete an user/admin: `renton$ bin/rails r lib/users/users_management.rb delete`
- List all users and admins: `renton$ bin/rails r lib/users/users_management.rb list`

## Security (HTTP Digest)

This application uses HTTP Digest in the authentication process, applying a hash function to the password before sending it over the network.

However, the rest of information is sended as a plain text, so its highly recommendable to use HTTPS (TLS/SSL in transport layer) if its possible. Using HTTPS, the HTTP Digest can be replaced by the HTTP Basic Authentication. 

