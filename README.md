# Challah

[![Build Status](https://secure.travis-ci.org/jdtornow/challah.png)](http://travis-ci.org/jdtornow/challah) [![Dependency Status](https://gemnasium.com/jdtornow/challah.png?travis)](https://gemnasium.com/jdtornow/challah)

Challah (pronounced HAH-lah) is a simple Rails authentication gem that provides users a way to authenticate with your app. Most of the functionality within the gem lives within a Rails engine and tries to stay out of the way of your app.

Challah doesn’t provide any fancy controllers or views that clutter your app or force you to display information a certain way. That part is up to you. The functionality within Challah is designed to be a starting point for users and sign-ins you can tweak the rest to your app’s needs.

## Requirements

* Ruby 1.9.2+
* Bundler
* Rails 3.1+

## Installation

    gem install challah

Or, in your `Gemfile`

    gem 'challah'

## Set up

Once the gem has been set up and installed, run the following command to set up the database migrations:

    rake challah:setup

This will copy over the necessary migrations to your app, migrate the database and add some seed data. You will be prompted to add the first user as the last step in this process.

### Manual set up

If you would prefer to handle these steps manually, you can do so by using these rake tasks instead:

    rake challah:setup:migrations
    rake db:migrate
    rake challah:setup:seeds
    rake challah:users:create

### Creating users

Since Challah doesn’t provide any controller and views for users there are a few handy rake tasks you can use to create new records.

Use the following task to create a new user:

    rake challah:users:create           # => Creates a new User record

## Models

Challah provides the core `User` model for your app, and a database migration to go along with it. You can customize the model to your app's specific needs, just leave the `challah_user` line intact.

A user is anyone that needs to be able to authenticate (sign in) to the application. Each user requires a first name, last name, email address, username, and password.

By default a user is marked as “active” and is able to log in to your application. If the active status column is toggled to false, then this user is no longer able to log in. The active status column can be used as a soft-delete function for users.

### Permissions and Roles

As of version 0.7.0 of Challah, permissions and roles have been moved to their own gem in [Challah Rolls](https://github.com/jdtornow/challah-rolls). Add this gem to your project to get additional functionality for permissions and role based restrictions.

## Checking for a current user

The basic way to restrict functionality within your app is to require that someone authenticate (log in) before they can see it. From within your controllers and views you can call the `current_user?` method to determine if someone has authenticated. This method doesn’t care about who the user is, or what it has access to, just that it has successfully authenticated and is a valid user.

For example, restrict the second list item to only users that have logged in:

    <ul>
      <li><a href=”/”>Home</a></li>

      <% if current_user? %>
        <li><a href=”/secret-stuff”>Secret Stuff</a></li>
      <% end %>

      <li><a href=”/public-stuff”>Not-so-secret Stuff</a></li>
    </ul>

Controllers can also be restricted using `before_filter`:

    class WidgetsController < ApplicationController
      before_filter :signin_required

      # …
    end

Or, you can call `restrict_to_authenticated` instead, which does the same thing:

    class WidgetsController < ApplicationController
      restrict_to_authenticated

      # ...
    end

All normal Rails `before_filter` options apply, so you can always limit this restriction to a specific action:

    class WidgetsController < ApplicationController
      restrict_to_authenticated :only => [ :edit, :update, :destroy ]

      # ...
    end

## Default Routes

By default, there are a few routes included with the Challah engine. These routes provide a basic method for a username- and password-based sign in page. These routes are:

    GET   /sign-in      # => SessionsController#new
    POST  /sign-in      # => SessionsController#create
    GET   /sign-out     # => SessionsController#new

Feel free to override the `SessionsController` with something more appropriate for your app.

If you’d prefer to set up your own “sign in” and “sign out” actions, you can skip the inclusion of the default routes by adding the following line to an initializer file in your app:

    Challah.options[:skip_routes] = true

Note: These routes have changed from previous versions of Challah. `signin_path` and `signout_path` are now the preferred routes, instead of the legacy `login_path` and `logout_path`. However, the legacy routes still remain for backward compatibility.

## Sign In Form

By default, the sign in form is tucked away within the Challah gem. If you’d like to customize the markup or functionality of the sign in form, you can unpack it into your app by running:

    rake challah:unpack:views        # => Copy the sign in view into your app

If necessary, the sessions controller which handles creating new sessions and signing users out can also be unpacked into your app. This is really only recommended if you need to add some custom behavior or have advanced needs.

    rake challah:unpack:signin        # => Copy the sessions controller into your app

## Full documentation

Documentation is available at: [http://rubydoc.info/gems/challah](http://rubydoc.info/gems/challah)

## Example App

A fully-functional example app, complete with some basic tests, is available at [http://challah-example.herokuapp.com/](http://challah-example.herokuapp.com/).

The source code to the example is available at [https://github.com/jdtornow/challah-example](https://github.com/jdtornow/challah-example).

### Issues

If you have any issues or find bugs running Challah, please [report them on Github](https://github.com/jdtornow/challah/issues). While most functions should be stable, Challah is still in its infancy and certain issues may be present.

### Testing

Challah is fully tested using Test Unit, Shoulda and Mocha. To run the test suite, `bundle install` then run:

    rake test

## License

Challah is released under the [MIT license](http://www.opensource.org/licenses/MIT)

Contributions and pull-requests are more than welcome.
