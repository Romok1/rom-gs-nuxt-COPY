# GEF Spatial

This project has a front and backend distinction that makes it differ from the
way that Rails projects are usually deployed.

It is built using Nuxt as the frontend framework (wrapped around Vue.js 2) and
Ruby on Rails (version 7) in API mode for the backend (with Ruby 3.1.0).

## Setup

1. Clone repo - `git clone git@github.com:unepwcmc/gef-spatial.git`
2. Copy 'gef-spatial/nuxt-frontend/.env' from password
manager to repo
3. Copy 'gef-spatial/rails-api/config/master.key' from
password manager to repo, run `bin/rails credentials:edit` and add the credentials
from 'GRIP credentials'
4. Copy 'gef-spatial/rails-api/config/test/test.key' from
password manager to repo, run `bin/rails credentials:edit --environment test` 
and add the credentials from 'GRIP credentials - test'
5. Open a couple of terminal tabs, one for the 'nuxt-frontend' subdirectory
and one for the 'rails-api' subdirectory
6. **Nuxt:** use the correct Node version - `nvm use` (if not present, install
then reinstall yarn - `nvm install 16.8.0 && npm install -g yarn`)
7. **Rails:** install dependencies - `bundle install`
8. Ensure that Redis is installed and running.
9. **Rails:** with any seed files in place, hydrate database -
`bundle exec rake db:drop db:create db:migrate db:seed`
10. **Rails** import the full GEF dataset - `rake import:sharepoint_data` (optional)
11. **Nuxt:** install dependencies - `yarn install`

## Local use

### Server startup

1. **Rails:** start server - `bundle exec rails s`
2. **Nuxt:** start server - `yarn dev`

### Links

- **Frontend (Nuxt):** [http://localhost:8080](http://localhost:8080)
- **Tailwind config viewer:** [http://localhost:8080/_tailwind](http://localhost:8080/_tailwind/)
- **API:** [http://localhost:3000/v1](http://localhost:3000/v1) (see note below about API calls)

## Data

### Importing data

Data for this application will be imported and synced from spreadsheets stored on the UNEP-GEF sharepoint. Until this is implemented, data is imported from CSV copies of the spreadsheets in `/rails-api/db/data`. On deployment, these should be imported by running the rake task with `rake import:sharepoint_data` from the `/rails-api` directory.

## Notes

* API calls from frontend AJAX should go to `/api` which is proxied against the
`.env/RAILS_ENDPOINT` and should usually be something like `http://localhost:3000/v1`,
so replace the `v1` with `api` when making requests to the API
* See 'gef-spatial/rails-api/db/data/users.yml' for test
users you can use with the backend ([http://localhost:8080/admin](http://localhost:8080/admin))

To learn more about this project, please see the
[Wiki](https://github.com/unepwcmc/gef-spatial/wiki).
