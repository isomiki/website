# How to create a Rails + Hotwire website

> **You only need the first 7 steps, the rest is extra info.**

This guide is written for Unix systems. If you're using Windows, [get help](https://988lifeline.org/)

btw this website uses Hotwire and you can get the code on [GitLab](https://gitlab.com/mrnb/marinbelec-website/-/tree/hotwire).

---

1. Install Ruby and Rails

Use rvm. In your terminal, run:

```bash
\curl -sSL https://get.rvm.io | bash -s stable --rails
```

2. Create a new Rails project

```bash
rails new your-project-name --database=sqlite3
```

And cd into it (`cd your-project-name`).

The database is optional (you can leave out `--database=sqlite3`) and you can add it later.

3. Install packages

```bash
bundle install
```

4. If you added a database before, create it

```bash
bin/rails db:create
```

5. Install Hotwire

```bash
bin/rails hotwire:install
```

6. Create some pages and controllers for them

I'll create home, about, posts and contact.

```bash
bin/rails generate controller Pages home about posts contact
```

Controllers are for backend logic that runs on your server and not in the browser. You probably don't need a controller for most pages so you can leave out the `controller` part.

You can add more pages and controllers later with the same command.

7. Run the server

```bash
bin/rails server
```

If everything works, the setup is done and you can start coding.

---

## Where to write your code

Your pages are in `app/views/pages/` in files like `example.html.erb`. These are "Embedded Ruby" files, you can write Ruby and HTML in here and they will be rendered into pure HTML when served. You _could_ also write CSS and JavaScript in here but you should use a global stylesheet and separate your JS into controllers, that's how Hotwire was intended to be used.

Take a look inside `config/routes.rb` - this is where the routing is defined. The `generate` command we ran before already set up routes for our pages, but you can change it.

### Global CSS

To change global styles, edit `app/assets/stylesheets/application.css`

### Adding Ruby code

You should write Ruby code inside the controller files in `app/controllers/` or in helper files in `app/helpers/`. The Ruby code is executed on the server so you should do sensitive operations here.

Controllers handle the business logic and the flow of data, e.g. handling form submissions, updating the database or rendering UI. Their names must end with `_controller.rb`.

Helpers are for organizing and simplifying the logic used in views, e.g. formatting data or making some calculations. Their names must end with `_helper.rb`.

Here's an example of using some computed data:

Edit `app/helpers/application_helpers.rb`. This is available throughout your app. Use this code to get the current data:

```ruby
module ApplicationHelper
  def current_date_example
    Date.today.to_s
  end
end
```

Then edit `app/views/pages/home.html.erb` and add this:

```html
<p><%= current_date_example %></p>
```

Restart your server.

Now when you visit your homepage (at `/`) you will see the current date.

Of course, you could also inline that and skip the helper:

```html
<p><%= Date.today.to_s %></p>
```

### Adding JavaScript code

Hotwire uses a JavaScript framework called Stimulus. The JS code is executed in the client browser so you shouldn't do sensitive operations here.

To write a script, create a controller file in `app/javascript/controllers/` and call it `example_controller.js`. It needs the `_controller` at the end of the name.

Then attach the controller to an element in your HTML using the `data-controller` attribute, like this:

```html
<div data-controller="example">...</div>
```

`"example"` should match the controller name (in `example_controller.js`) so that Stimulus can attach it.

Now add some code to your controller. Inside `example_controller.js`, use this structure:

```js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Code inside connect() runs when the attached HTML element first loads
    example();
  }

  disconnect() {
    // Code inside disconnect() runs when the element unloads
  }

  // You can write your functions here and call them in connect() or disconnect()
  sayHi() {
    console.log("Hi");
  }
}
```

For more details, read the official docs: [Stimulus Controllers](https://stimulus.hotwired.dev/reference/controllers)

## Adding a database after setup

If you didn't add a database during initial setup, here's how you can add it afterwards.

1. Add SQLite3 to your `Gemfile` by adding this line

```Gemfile
gem 'sqlite3'
```

2. Install the gem. In your terminal from inside your project, run

```bash
bundle install
```

3. Generate the database

```bash
bin/rails db:create
```

4. Run migrations to set up the schema

```bash
rails db:migrate
```

## Notes

The app will automatically show changes when you edit your `.html.erb` files. But if you make changes to other things then you need to restart your server (Stop it with `ctrl+c` and then run `bin/rails server`).

For some changes, e.g. CSS files, JS files, adding new dependencies, you should also clean out precompiled and cached assets and generate new ones, like this:

```bash
bin/rails assets:clobber && bin/rails assets:precompile
```

## Hosting your app

If you want to host your Hotwire app somewhere, read [this](/posts/005-how-to-host-rails-app-on-coolify).
