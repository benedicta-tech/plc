module Fastlane
  module Actions
    module SharedValues
      BUMP_VERSION_FLUTTER_CUSTOM_VALUE = :BUMP_VERSION_FLUTTER_CUSTOM_VALUE
    end

    class BumpVersionFlutterAction < Action
      def self.run(params)
        pubspec = YAML.load(File.read("pubspec.yaml"))
        version_name, version_code = pubspec["version"].split("+")
        puts("\nCurrent Version: #{version_name}")
        new_version = params[:version] + "+#{version_code.to_i + 1}"
        puts("New Version: #{new_version}")
        pubspec["version"] = new_version
        File.open("pubspec.yaml", "w") { |file| file.write(pubspec.to_yaml) }
        Actions.lane_context[SharedValues::BUMP_VERSION_FLUTTER_CUSTOM_VALUE] = "bumped version to #{new_version}"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'A short description with <= 80 characters of what this action does'
      end

      def self.details
        'You can use this action to do cool things...'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: 'Version to bump to',
                                       is_string: true,
                                       )
        ]
      end

      def self.output
        [
          ['BUMP_VERSION_FLUTTER_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ['Your GitHub/Twitter Name']
      end

      def self.is_supported?(platform)
          true
      end
    end
  end
end
