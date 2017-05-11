# Enumish

Enumish is "Database-backed Enum for ActiveRecord".

It gives you the ability to create Enum-like properties directly in the database.

[![Build Status](https://travis-ci.org/cmer/enumish.svg?branch=master)](https://travis-ci.org/cmer/enumish)

## Simple Example

Given a model:

````ruby
class Color < ActiveRecord
  include Enumish
end
````

You could do things such as:

````ruby
color = Color.blue  # gets the color blue from the database
color.blue?         # => true
color.red?          # => false
color.to_s          # => "blue"
color.to_sym        # => :blue
color.id            # returns the ID from the database

Color.not_a_color  # raises MethodNotFound
````

## A-bit-more-advanced-but-still-simple Example

You can combine Enumish with any other ActiveRecord functionality or Gems. For example,
here's a model that uses Enumish and RankedModel, as well as some custom code.

````ruby
class Color < ActiveRecord
  include RankedModel
  ranks :position
  include Enumish

  class << self
    def select_options
      Color.rank(:position).where(enabled: true).map do |s|
        { s.human_description => s.id }
      end
    end

    def all_primary
      Color.rank(:position).where(enabled: true).where(primary: true)
    end
  end

  def human_description
    "The color #{self.to_s}"
  end
end
````

Such a model allows you, for example, to have a relationship between two models such as:

````ruby
class Car < ActiveRecord
  has_one :color
end

car = Car.new
car.color = Color.blue
car.save!

car.color.blue?          # => true
car.color.red?           # => false
car.color == Color.blue  # => true
car.color_id             # => Integer

# NOTE: table `cars` has column `color_id` of type `integer`
````

The method `.select_options` above could be used to populate an HTML `select` element.
The value of each element would be the `id` of the corresponding `Color` record.

## Migration

For each model that includes Enumish, add a column named `short` of type `string`. This
column will be used to store the "short" representation of the record. It will also be used
as a method name, so make sure it only contains characters that are valid in a Ruby method name.

````ruby
class CreateColors < ActiveRecord::Migration[5.0]
  def change
    create_table :colors do |t|
      t.string :short, null: false   # << This!
      t.string :long, null: false
      t.boolean :enabled, default: true, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
````

If you'd rather name the column something else, you can override the `enum_id` method in your
model:

````ruby
class Color < ActiveRecord
  include Enumish

  def enum_id
    :enum_value
  end
end
````

## Why not just use ActiveRecord::Enum?

Glad you asked! [`ActiveRecord::Enum`](http://api.rubyonrails.org/classes/ActiveRecord/Enum.html)
(AR::E going forward) is an option you should definitely consider if it fits your needs. I wrote
Enumish because I needed the following capabilities:

- Ability to have more than one enum field per model.

  For example, a `Car` model could have the following Enumish properties:
  `exterior_color`, `interior_color`, `model`, `transmission`. This would not be possible
  with vanilla AR::E.

- Database-backed properties. There are many benefits to this. Notably, Enumish allows you to:

    - Maintain an ever-evolving list of properties directly in the database instead of changing
      and potentially breaking code. Your marketing team will love this!
    - Keep a human-readable version of your Enumish properties in the database for your users
      to see, or for your eyes only. Just add a `description` column.
    - Enable or disable some properties. Just add an `enabled` column.
    - Sort how properties are displayed to end-users. Pro-tip, just use
      [`RankedModel`](https://github.com/mixonic/ranked-model).
    - Limit possible Enumish properties under different circumstances. For example, a car from 2015
      might have different color options than a car from 2016. Or in the example above, I have
      an `.all_primary` method that only returns primary colors.
    - Perform database `JOIN`s between your model and Enumish models.
    - Maintain data integrity between your models and Enumish models. It's all just SQL after all.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enumish'
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

