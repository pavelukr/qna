FactoryBot.define do
  factory :attachment do
    file { File.open 'spec/spec_helper.rb' }
  end
end
