## Rails API & Controller Standards

- **RESTful Resources**: Use `resources` in routes. Standard actions: `index`, `show`, `new`, `create`, `edit`, `update`, `destroy`
- **Turbo Responses**: Return `turbo_stream` for dynamic updates, HTML for full page loads
- **Strong Parameters**: Always use `params.require(:model).permit(:field1, :field2)`
- **Before Actions**: Use callbacks for authentication, authorization, resource loading
- **Respond To**: Use `respond_to` blocks when supporting multiple formats

```ruby
# Good: RESTful controller with Turbo
class RacesController < ApplicationController
  before_action :set_race, only: [:show, :edit, :update, :destroy]

  def index
    @races = Race.upcoming.order(:date)
  end

  def create
    @race = Race.new(race_params)
    if @race.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @race, notice: "Race created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_race
    @race = Race.find(params[:id])
  end

  def race_params
    params.require(:race).permit(:name, :date, :location, :description)
  end
end
```
