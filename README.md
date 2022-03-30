[![CI Status](https://github.com/ArcadiaPower/fast-versioning/workflows/CI/badge.svg?branch=master)](https://github.com/ArcadiaPower/fast-versioning/actions?query=workflow%3ACI+branch%3Amaster)

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

Prerequisites
-------------
- PaperTrail needs to be added to your model
- Storing changes needs to be enabled for PaperTrail
- Attributes tracked with FastVersioning need to also be present in PaperTrail
ie.
```ruby
has_paper_trail only: :status
has_fast_versions :status
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
### Creating and recreating fast versions
FastVersioning versions are created based on the `PaperTrail::Version` instance. When available, the `changeset` is used, otherwise, FastVersioning will attempt to `reify` the object comparing the changes for the tracked columns.

At any point you can retroactively recreate FastVersioning versions (especially, initially, when adding fast versions to existing PaperTrail configuration, or when adding/changing FastVersioning options for a model), to do so you need to call the `recreate_fast_versions!` on the `PaperTrail::Version` instance. It will destroy all previous fast versions if they exist and recreate them.

Example usage:
```ruby
    # recreate fast versions for a single model instance
    your_model.versions.find_each(&:recreate_fast_versions!)

    # recreate fast versions for all model instances
    YourModel.find_each { |your_model| your_model.versions.find_each(&:recreate_fast_versions!) }
```

### Querying
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

    # alternatively:
    FastVersioning::FastVersion.find_by(
      item_type: 'ItemType',
      name: 'name',
      value: 'value'
      prev_value: 'prev_value'
    )
```

### Timeline helper
`FastVersioning::Timeline` is a simple helper you can use to generate a timeline hash for a tracked property

example usage:
```ruby
FastVersioning::Timeline.new(
  fast_versions: model.fast_versions,
  name: "status"
).to_h

# {
#   Thu, 01 Apr 2021 14:08:48 EDT -04:00..Mon, 05 Apr 2021 21:53:48 EDT -04:00 => 'active',
#   Mon, 05 Apr 2021 21:53:48 EDT -04:00..Mon, 05 Apr 2021 22:02:44 EDT -04:00 => 'inactive',
#   Mon, 05 Apr 2021 22:02:44 EDT -04:00..Infinity => 'active'
# }
```

Testing
-------------
```
bundle exec appraisal install
bundle exec appraisal rspec
```

An [Arcadia](http://www.arcadia.com) Project
