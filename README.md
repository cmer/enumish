# Enumish

Enumish is "Enum for ActiveRecord".

It gives you the ability to create Enum-like values directly in the database.

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
  end

  def description
    "#{self.to_s} is a beautiful color!"
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

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enumish'
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

