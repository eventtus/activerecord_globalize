# ActiveRecord Globalize [![Build Status](https://travis-ci.org/mohamedelfiky/activerecord_globalize.svg?branch=master)](https://travis-ci.org/mohamedelfiky/activerecord_globalize) [![Code Climate](https://codeclimate.com/github/mohamedelfiky/activerecord_globalize/badges/gpa.svg)](https://codeclimate.com/github/mohamedelfiky/activerecord_globalize) [![Test Coverage](https://codeclimate.com/github/mohamedelfiky/activerecord_globalize/badges/coverage.svg)](https://codeclimate.com/github/mohamedelfiky/activerecord_globalize/coverage) [![Inline docs](http://inch-ci.org/github/mohamedelfiky/activerecord_globalize.svg?branch=master)](http://inch-ci.org/github/mohamedelfiky/activerecord_globalize)

Rails I18n library for ActiveRecord model/data translation using PostgreSQL's hstore datatype. It provides an interface inspired by hstore_translate but without the need for data migrations (zero down time solution for large set of data).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_globalize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord_globalize

## Usage

You'll need to define an hstore column for each of your translated attributes, using the suffix "_translations":

```ruby
class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.column :title_translations, 'hstore'
      t.column :body_translations,  'hstore'
      t.timestamps
    end
  end
  def down
    drop_table :posts
  end
end
```
then run rake `db:migrate`

If you got an error `PG::UndefinedObject: ERROR: type "hstore" does not exist` add `enable_extension 'hstore'` before creating hstore columns in migration file to enable hstore extention on postgres db.

Model translations allow you to translate your models' attribute values.

```ruby
class Post < ActiveRecord::Base
  translates :title, :body
end
```

Allows you to translate the attributes :title and :body per locale:

```ruby
I18n.locale = :en
post.title # => This database rocks!

I18n.locale = :he
post.title # => אתר זה טוב
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/mohamedelfiky/activerecord_globalize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
