# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

User.create(
  [
    { username: 'star_wars', email: 'star.wars@example.com', admin: true, password: 'star.wars1' },
    { username: 'lord_of_the_rings', email: 'lordoftherings@example.com', password: 'lord.of.the.rings'}
  ]
)
