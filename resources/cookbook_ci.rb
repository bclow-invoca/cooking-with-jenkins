actions :create, :delete, :disable, :enable
default_action :create

attribute :name,          :kind_of => String, :name_attribute => true
attribute :repo,          :kind_of => String
attribute :branch,        :kind_of => String, :default => "master"
attribute :foodcritic,    :kind_of => String, :default => true
attribute :chefspec,      :kind_of => String, :default => true
attribute :serverspec,    :kind_of => String, :default => true
attribute :junit_results, :kind_of => String, :default => false

attr_accessor :attribute, :attribute

provides :cookbook_ci, os: ['linux']
