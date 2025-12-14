## Active Record Query Standards

- **Use Scopes**: Define reusable queries as model scopes
- **Eager Load**: Use `includes` to prevent N+1 queries
- **Select Only Needed**: Use `select` for large result sets
- **Use Pluck**: Use `pluck` when you only need array of values
- **Transactions**: Wrap related writes in `transaction` block

```ruby
# Bad: N+1 query
@races = Race.all
@races.each { |r| puts r.organizer.name }

# Good: Eager load association
@races = Race.includes(:organizer).upcoming

# Good: Select specific columns
Race.select(:id, :name, :date).upcoming

# Good: Pluck for simple values
Race.upcoming.pluck(:name)

# Good: Transaction for related writes
Race.transaction do
  race = Race.create!(race_params)
  race.registration_periods.create!(period_params)
end
```

**Index Strategy**: Index columns used in:
- `WHERE` clauses (e.g., `date`, `city`, `status`)
- `ORDER BY` clauses
- Foreign keys
- Unique constraints
