## Rails Error Handling Standards

- **Rescue at Controller Level**: Handle errors in `ApplicationController` or specific controllers
- **User-Friendly Pages**: Use `public/404.html`, `public/500.html` for error pages
- **Specific Exceptions**: Rescue specific exceptions, not `StandardError`
- **Fail Fast**: Validate early in controllers; use `find` (raises) vs `find_by` (returns nil)

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end

  def bad_request
    render file: Rails.public_path.join("400.html"), status: :bad_request, layout: false
  end
end

# Good: Use find (raises RecordNotFound)
@race = Race.find(params[:id])

# Good: Handle validation failures
def create
  @race = Race.new(race_params)
  if @race.save
    redirect_to @race
  else
    render :new, status: :unprocessable_entity
  end
end
```

**Production Error Tracking**: Configure error service (Sentry, Honeybadger) in `config/initializers/`.
