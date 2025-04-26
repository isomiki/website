## How to create a Ruby on Rails website using Hotwire

This guide is written for Unix systems. If you're using Windows, [get help](https://988lifeline.org/)

1. Install Ruby and Rails on your system. Use rvm.

```bash
\curl -sSL https://get.rvm.io | bash -s stable --rails
```

2. Create a new project with Rails

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

8. Now you can edit your page files

Your pages are in `app/views/pages/`. These are ruby files, you can write Ruby and HTML in here. You can write CSS and JavaScript too but I like to use a global stylesheet and separate my JS.

### CSS:

To change global styles, edit `app/assets/stylesheets/application.css`

### JS:

To write page-specific scripts, edit `app/controllers/pagename_controller.js` e.g. `example_controller.js`, then attach it in your page's .erb file like this:

```html
<div data-controller="example">...</div>
```

### Adding a database

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

### Notes

The app will automatically reload when you make changes to the HTML. But if you make changes to the CSS or to things like controllers or the router, you need to restart your server (ctrl+c to stop it and then run `bin/rails server`).

Next you'll probably want to host it somewhere. Read [this](/posts/005-hosting-hotwire-on-coolify)
