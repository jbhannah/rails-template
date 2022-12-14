# frozen_string_literal: true

# Add an `.inverse_of` scope to including models that takes a scope name as a
# parameter, inverts the `WHERE` clause of that scope, and appends it to the
# query chain. This isolates the application of `#invert_where` to the
# specified scope, which prevents it from inadvertently inverting any other
# scopes or conditions in the query chain.
#
# https://jbhannah.net/articles/rails-7-using-invert-where-safely
module ScopeInverter
  extend ActiveSupport::Concern

  included do
    scope :inverse_of, ->(scope) { self.and(klass.send(scope).invert_where) }
  end
end
