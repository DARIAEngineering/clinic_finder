# clinic_finder
# ABORTRON 

* CI: https://travis-ci.org/colinxfleming/clinic_finder
* build script: build.sh
* run tests: rake test

## Problem Description

Our case management team is helping patients navigate a variety of logistical challenges to securing an abortion, such as figuring out the closest clinic to them, or the cheapest clinic in their state, or a clinic that will still see them (since many clinics have a gestational age cutoff after which they won't do abortions anymore). The DC area is fortunate enough to have a variety of providers, and we'd like to have a tool that helps us filter down our set of clinics and help our case managers recommend an optimal few clinics, given a patient's particular needs.

## How we'd like to use it

We'd prefer this as a ruby library so that we can plug it into our existing case management system easily. If that's not an option, we can adapt the logic from it.

## How we'd like it to work

As a case manager, given that I have:
* A patient with limited resources, a gestational age, and a zip code
* A set of clinics with certain attributes, including an address and a set schedule of costs and whether or not they accept National Abortion Federation (NAF) funding, and certain other factors that might make them a better fit for a patient

I would like to be able to filter and sort down to a subset of available clinics.

Relevant parts of our clinic objects that we'd like to filter on:
  * zip: five digit zip code
  * cost: cost in dollars for an abortion procedure
  * gestation_limit: limit in days, at which point a clinic won't perform abortions. e.g. no abortions after 147 days (21 weeks).
  * naf_clinic: boolean value for whether or not a clinic accepts NAF funding (e.g. whether or not we can count on a grant)

Information from a patient that we'd like to plug into the tool:
* zip code of patient
* patient's gestational age

## Setup

[PLACEHOLDER FOR INSTALL INSTRUCTIONS]

This gem currently requires data to be in the form of a .yml file, which is passed in to the library instance at the point of initialization as such:

`Abortron::ClinicFinder.new(yaml_file)`

The gem expects yml data to be in the following format:

```
planned_parenthood_oakland:
  street_address: 1001 Broadway
  city: Oakland
  state: CA
  zip: 94607
  accepts_naf: false
  gestational_limit: 139
  costs_9wks: 425
  costs_12wks: 475
  costs_18wks: 975
  costs_24wks: null
  costs_30wks: null
  ```
Hot tip: Before using your yml file, please be sure to feed it through a YAML linter like [YAML Lint](http://www.yamllint.com/) to remove any syntax errors.

Long term goal here is to make this usable with ActiveRecord models directly.

## Methods

First, you will need to instantiate a library instance.

`@abortron = Abortron::ClinicFinder.new(your_yaml_file)`

To find the cheapest clinic within your dataset that will serve the patient based on their LMP, call:

`@abortron.locate_cheapest_clinic(patient_zip: 94114, gestational_age: 60)`

This will return an array of hashes that look like so:

```
=> [{'planned_parenthood_oakland' => {'street_address' => '1001 Broadway', 
                                      'city' => 'Oakland', 'state' => 'CA', 
                                      'zip' => 94607, 
                                      'accepts_naf' => false, 
                                      'gestational_limit' => 139, 
                                      'costs_9wks' => 425, 
                                      'costs_12wks' => 475, 
                                      'costs_18wks' => 975, 
                                      'costs_24wks' => nil, 
                                      'costs_30wks' => nil}}, 
    {'castro_family_planning' =>     {'street_address' => '5464 Folsom', 
                                      'city' => 'San Francisco', 
                                      'state' => 'CA', 
                                      'zip' => 94607, 
                                      'accepts_naf' => false, 
                                      'gestational_limit' => 139, 
                                      'costs_9wks' => 425, 
                                      'costs_12wks' => 475, 
                                      'costs_18wks' => 975, 
                                      'costs_24wks' => nil, 
                                      'costs_30wks' => nil}}]
```
      

## Further goals
* Make gem usable with ActiveRecord models directly, instead of via a yml file that requires maintenance
* Incorporate check for NAF only (the infrastructure is currently present as a default-false argument, but is not being used)
* Create method for cheapest **and** closest, defined as the cheapest clinic of your three closest clinics
* Create a method for easiest/fastest access via public transportation (this may require patient to provide full address, not just zip)

## Measuring success

We'd like to walk away with:

* A ruby gem that we can install in a separate app
* A standalone sinatra app that we can demo to case managers
