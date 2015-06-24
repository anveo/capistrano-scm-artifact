require "capistrano/scm"
require "fog"

load File.expand_path("../tasks/artifact.rake", __FILE__)

set_if_empty :artifact_region_query, 'echo us-east-1'

class Capistrano::Artifact < Capistrano::SCM
  module DefaultStrategy
    def check
      fetch(:artifact_aws_buckets).each do |bucket|
        connection = Fog::Storage.new({
          provider:  "AWS",
          aws_access_key_id: fetch(:artifact_aws_access_key),
          aws_secret_access_key: fetch(:artifact_aws_secret_key),
          region: bucket[:region]
        })
        item = fetch(:artifact_pattern)
        artifact = connection.directories.get(bucket[:name]).files.head(item)

        raise "Unable to download asset #{item} from any mirrors, ensure it was built!" unless artifact
      end
    end

    def asset_url(region = "us-east-1")
      bucket_info = fetch(:artifact_aws_buckets).find { |b| b[:region] == region}

      connection = Fog::Storage.new({
        provider:  "AWS",
        aws_access_key_id: fetch(:artifact_aws_access_key),
        aws_secret_access_key: fetch(:artifact_aws_secret_key),
        region: bucket_info[:region]
      })
      item = fetch(:artifact_pattern)
      connection.directories.get(bucket_info[:name]).files.head(item).url(Time.now + 600)
    end

    def region
      context.capture(fetch(:artifact_region_query)).chomp
    end
  end
end
