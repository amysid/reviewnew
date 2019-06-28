# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "admin", email: "admin@example.com", c_code: "+91", mobile_no: "11111111111", role: 0,password: "password",confirmed_at: (DateTime.now.utc)) unless  User.find_by(email: 'admin@example.com',role: 0)

["Terms & Condition","Privacy Policy", "About us","Contact us"].map{|x|
StaticContent.create(title: x,description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget.") unless StaticContent.find_by(title: x)
}