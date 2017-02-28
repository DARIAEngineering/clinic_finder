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

So what I think we can do is something like (in ruby-ese):


```
Abortron.locate_closest_clinic(Clinic.all, patient_zip: 20011, gestational_age: 130)
# => should return clinic objects that is the fewest miles away from the patient zip, and that's still seeing patients at that gestational age, both NAF and not-NAF clinics

Abortron.locate_cheapest_clinic(Clinic.all, patient_zip: 20011, gestational_age: 130, naf_clinics_only: true)
# => should return clinic objects that is the lowest cost, and that's still seeing patients at that gestational age, and only NAF clinics

Abortron.locate_best_clinics(Clinic.all, patient_zip: 20011, gestational_age: 130)
# => should return a set of closest clinics and cheapest clinics, both NAF and non-NAF clinics
```

My hope is that this is nice and straightforward, that the core engine is fairly straightforward, and that it's a weekend-sized project that we can push into production almost immediately.

## Measuring success

We'd like to walk away with:

* A ruby gem that we can install in a separate app
* A standalone sinatra app that we can demo to case managers
