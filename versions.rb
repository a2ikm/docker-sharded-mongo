#!/usr/bin/env ruby

require "json"
require "net/http"
require "set"
require "uri"

JSON_URL = "https://downloads.mongodb.org/current.json"
MIN_MAJOR_VERSION = 4
SKIPPED_MINOR_VERSIONS = ["5.3", "6.1"]

minor_versions = Set.new

json = Net::HTTP.get(URI(JSON_URL))
JSON.parse(json)["versions"].each do |version_hash|
  version = version_hash["version"]
  next unless version.match?(/\A\d+\.\d+\.\d+\z/)

  major, minor, _ = version.split(".").map(&:to_i)
  next unless MIN_MAJOR_VERSION <= major

  minor_version = "#{major}.#{minor}"
  next if SKIPPED_MINOR_VERSIONS.include?(minor_version)

  minor_versions << minor_version
end

puts JSON.pretty_generate(minor_versions.to_a.sort)
