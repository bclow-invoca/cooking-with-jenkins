actions :create, :delete, :disable, :enable
default_action :create

attribute :name,          :kind_of => String,                  :name_attribute => true
attribute :repository,    :kind_of => String,                  :required => true
attribute :branch,        :kind_of => String,                  :default => "master"
attribute :foodcritic,    :kind_of => [TrueClass, FalseClass], :default => true
attribute :chefspec,      :kind_of => [TrueClass, FalseClass], :default => true
attribute :serverspec,    :kind_of => [TrueClass, FalseClass], :default => true
attribute :junit_results, :kind_of => [TrueClass, FalseClass], :default => false
attribute :command,       :kind_of => String,                  :default => "base"

attr_accessor :attribute, :attribute

provides :cookbook_ci, os: ['linux']
