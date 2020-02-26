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
* Used Bootstrap to simplify the process of making the interface pretty
* Architecture of the app is a sort of a hybrid of a SPA and standard Rails App
  - Dashboard for notes harnesses a Rails backend API serving notes data in JSON form
  - Devise views and home page are routed by Rails
  - This was done because of the flexibility ReactJS + Bootstrap offers for the dashboard interface. I find it easier to make a non-static view with this technique
* Used Faker gem for the creation of fake data. This was way more fun than using Lorem Ipsum
* Used FactoryBot for tests (this might have been unneccesary)
