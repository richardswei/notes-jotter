# README

### Overview
NoteJotter is an application that allows notes to be taken on the fly. At the moment, users may create an account, log in create notes, view their notes, update notes and delete notes. There are demo accounts to try out on the sign in screen. TV show quotes and characters are supplied as dummy data.

### RSpec Test suite:
These tests cover the GET, POST, PUT, DELETE actions for the notes API

in terminal, from project root:

```rspec ./spec/notes_spec.rb```

### Comments on decisions made
* Stated requirements in the challenge are generally covered. I decided not to pursue email functionality.
* Used Devise gem for authentication. Devise pretty much works out of the box, so this saved me at least a few hours by not having to implement and test my own JWT mechanisms.
* Used Faker gem for the creation of fake data. This was way more fun than using Lorem Ipsum
* Used FactoryBot for tests (this might have been unneccesary)
