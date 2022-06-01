#!/usr/bin/env ruby

require "json"
require "net/http"
require "set"
require "uri"

JSON_URL = "https://downloads.mongodb.org/current.json"
MIN_MAJOR_VERSION = 4

minor_versions = Set.new

json = Net::HTTP.get(URI(JSON_URL))
JSON.parse(json)["versions"].each do |version_hash|
  version = version_hash["version"]
  next unless version.match?(/\A\d+\.\d+\.\d+\z/)

  major, minor, _ = version.split(".").map(&:to_i)
  next unless MIN_MAJOR_VERSION <= major

  minor_versions << "#{major}.#{minor}"
end

puts JSON.pretty_generate(minor_versions.to_a.sort)
