# Jopi

A Gem to make defineing Json documents easy as pie.
It turns a document into components so you can re-use bits of it as well.
I still haven't quite worked out how you get the data into the resultant document however. 
The reason I'm creating this gem is becuase the only one (that I can find) is designed to work with rails, I wanted a gem that was data-agnostic, you describe the doucment by it's structure and then link it to the data source(probably through some 121 mapping scheme).

Wondering about the name? **J**s**o**n-a**pi**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jopi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jopi

## Usage

This describes a Document called 'forum_response'
```ruby

require 'lib/jopi'

Jopi::Document.define :forum_response do 
    links %w{self next last}
    data :array, :posts
    data :array, :included, %w{people comments}
end

Jopi::Template.define :general do |name,list_of_attributes|
    type name
    id
    attributes list_of_attributes
    links %w{self}
end

Jopi::Object.define :posts do
    template :general, :posts, %w{title}
    mixin :forum_post_relation
end

Jopi::Object.define :people do
    template :general, :people, %w{first-name last-name twitter}
end

Jopi::Object.define :comments do
    template :general, :comments, %w{body}
end

Jopi::Mixin.define :forum_post_relation do
    block :relationships do
        template :relations, :author, %w{self related}, :object
        template :relations, :comments, %w{self related}, :array
    end
end

Jopi::Template.define :relations do |name,list_of_links,type|
    block name do
        links list_of_links
        data type, :comments
    end
end

Jopi::Object.define :comments do
    type
    id
end
```

That can result in a document like this (taken from [jsonapi.org](jsonapi.org)):
```json
{
  "links": {
    "self": "http://example.com/posts",
    "next": "http://example.com/posts?page[offset]=2",
    "last": "http://example.com/posts?page[offset]=10"
  },
  "data": [{
    "type": "posts",
    "id": "1",
    "attributes": {
      "title": "JSON API paints my bikeshed!"
    },
    "relationships": {
      "author": {
        "links": {
          "self": "http://example.com/posts/1/relationships/author",
          "related": "http://example.com/posts/1/author"
        },
        "data": { "type": "people", "id": "9" }
      },
      "comments": {
        "links": {
          "self": "http://example.com/posts/1/relationships/comments",
          "related": "http://example.com/posts/1/comments"
        },
        "data": [
          { "type": "comments", "id": "5" },
          { "type": "comments", "id": "12" }
        ]
      }
    },
    "links": {
      "self": "http://example.com/posts/1"
    }
  }],
  "included": [{
    "type": "people",
    "id": "9",
    "attributes": {
      "first-name": "Dan",
      "last-name": "Gebhardt",
      "twitter": "dgeb"
    },
    "links": {
      "self": "http://example.com/people/9"
    }
  }, {
    "type": "comments",
    "id": "5",
    "attributes": {
      "body": "First!"
    },
    "links": {
      "self": "http://example.com/comments/5"
    }
  }, {
    "type": "comments",
    "id": "12",
    "attributes": {
      "body": "I like XML better"
    },
    "links": {
      "self": "http://example.com/comments/12"
    }
  }]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jopi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
