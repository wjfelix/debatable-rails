# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
categories = Category.create([{ category_name: 'Sports'}, { category_name: 'Politics'},
  { category_name: 'Social Issues'}, {category_name: 'Health/Wellness'},
  { category_name: 'Technology'}, { category_name: 'Science'},
  { category_name: 'Fashion'}, { category_name: 'Entertainment'},
  { category_name: 'Religion'}, { category_name: 'Environment'},
  { category_name: 'Wildlife'}, {category_name: 'Pets'},
  { category_name: 'Food'}, { category_name: 'Travel'},
  { category_name: 'Cars'}, {category_name: 'Philosophy'}])
