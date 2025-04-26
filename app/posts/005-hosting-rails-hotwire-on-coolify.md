## Hot to host a Rails + Hotwire website on Coolify

This guide assumes you already have your Rails + Hotwire app working.
If not, see [this guide](/posts/004-how-to-create-rails-hotwire-website.md).
It also assumes you have Coolify set up and running.

1. Make a git repo

Make a repo for your project and get its URL. If it's a private repo, you'll need to set up a private key in Coolify for it (not explained here).

2. Create a new application in Coolify

In the Coolify panel, go to "Projects", create a project if you didn't already, and create a new resource inside it (click "+ New" on top).

Select one of the git repository options under "Applications" and "Git Based". My repo is private so I select "Private Repository (with Deploy Key)", select my private key, and then
