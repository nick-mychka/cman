class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :nickname

  field :token do |user, options|
    options[:token]
  end
end
