## Rails Migration Standards

- **Reversible**: Use `change` method when Rails can auto-reverse; use `up`/`down` for complex migrations
- **One Change Per Migration**: Each migration handles one logical change
- **Descriptive Names**: `rails g migration AddCityToRaces city:string`
- **Index Foreign Keys**: Always add index when adding foreign key columns
- **Concurrent Indexes**: Use `algorithm: :concurrently` for large tables (requires `disable_ddl_transaction!`)

```ruby
# Good: Simple reversible migration
class AddCityToRaces < ActiveRecord::Migration[8.0]
  def change
    add_column :races, :city, :string
    add_index :races, :city
  end
end

# Good: Concurrent index on large table
class AddIndexToRacesOnDate < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_index :races, :date, algorithm: :concurrently
  end
end

# Good: Non-reversible with up/down
class MigrateRaceData < ActiveRecord::Migration[8.0]
  def up
    Race.where(status: nil).update_all(status: 'pending')
  end

  def down
    # Cannot reverse data migration
    raise ActiveRecord::IrreversibleMigration
  end
end
```
