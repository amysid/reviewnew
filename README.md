

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


    ################ Guide For Char Data by reviews ##################
    p= Product.find("f7010ec4-68ea-4215-8b92-35d1f22efbbb")
    u_type = 'Normal User'
    p.user_type = u_type 
    p = p.as_json(methods: [:average_criteria_by_product, :average_criteria_by_category, :average_criteria_by_sub_cat])
    p["user_type"] = u_type 
    ###########################