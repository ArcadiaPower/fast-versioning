Fast Versioning
===========
A [PaperTrail](https://github.com/airblade/paper_trail) extension for seamless fast key/value versioning of individual object attributes, which can be queried.

### Why?

PaperTrail stores version changes in one serialized column, which is great for keeping backups, undoing, etc. For querying and searching this is a real pain to use, and sometimes you need to track single column changes that you can query, use for statistics, quickly check last changes. You can also use Fast Versioning to track more complex object state changes!

### How?
We hook up to PaperTrail version creation, check if an object's tracked attribute changed and store any changes individually.

Installation
------------
1. Add to the Gemfile and bundle
```ruby
gem 'fast_versioning'
```
2. Install migrations
```shell
rake fast_versioning:install:migrations
```

Configuration
-------------
1. Include the concern in your model

```ruby
include FastVersioning::FastVersioned
has_paper_trail

    ...
# define what you want to track
has_fast_versions(
  :plan_id,
  :plan_type,
  status: {
    billed_statements: Proc.new { |account| account.utility_statements.count },
    static_value: 'text'
  }
)

# plan_id - is a attribute
# plan_type - is a custom method
# status - defines an additional serialized meta apart from storing property change
```

Usage
-----

### samples
```ruby
    your_model.fast_versions # get all fast versions
    your_model.fast_versions_for(:plan_type) # get fast versions for given property - chain
    your_model.fast_versions.last.version # get parent paper_trail version object
    your_model.fast_versions.last.item # get changed item
    your_model.fast_versions.last.name # property name
    your_model.fast_versions.last.value # get value
    your_model.fast_versions.last.prev_value # get value before the change

    # query
    your_model.fast_versions_for(:status).where(value: 'active').where(prev_value: 'incomplete')
```

An [Arcadia Power](http://www.arcadiapower.com) Project