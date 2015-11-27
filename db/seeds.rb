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

styles = DebateStyles.create([{ debate_style: 'Q n A'}, { debate_style: '1 v 1'},
  { debate_style: '2 v 2'}, { debate_style: '3 v 3'}, {debate_style: '4 v 4'},
  { debate_style: 'Firetalk'}, { debate_style: 'Discussion/Freetalk'}])
