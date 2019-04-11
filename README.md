# Oneirros2
(Re)implementation of the OneiRRos project as a Ruby on Rails application.
Designed to be fully self contained. Still in development. 
Contact me for any inquiries.

## Introduction
The OneiRRos Project aims to bring a platform for development of applications around [RivalRegions](http://rivalregions.com).
One of the first goals of the project is to provide an API for authentication and easy access to cached game data, gathered through scrapping of the main website.

## Deps
 * Resque for Background Jobs
 * Mechanize + Nokogiri for Scrapping
 * Influxer + InfluxDB backend for Timeseries handling
 * PostgreSQL as main data store
 * Yarn for JS Deps, such as UIkit
 * HAML for templated views
