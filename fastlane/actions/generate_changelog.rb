

module Fastlane
  module Actions
    module SharedValues
      GENERATE_CHANGELOG_CUSTOM_VALUE = :GENERATE_CHANGELOG_CUSTOM_VALUE
    end

    class GenerateChangelogAction < Action
      def self.run(params)
        pubspec = YAML.load(File.read("pubspec.yaml"))
        version_name, version_code = pubspec["version"].split("+")

        from = Actions.last_git_tag_name(true, nil)
        UI.verbose("Found the last Git tag: #{from}")
        to = 'HEAD'
        
        UI.success("Collecting Git commits between #{from} and #{to}")
        
        Dir.chdir('./') do
          changelog = Actions
            .git_log_between('format:$b>%s%n$r>%b', from, to, 'include_merges', nil, false,nil)
            .split("$b>")
            .filter { |line| line.length > 0 }
            .map { |i| i.split("$r>").map { |ni| ni.strip } }
            .map { |i| { title: i[0], notes: i[1].to_s.gsub("\\n", "\n") .gsub("\n\n", "\n") } }
            .filter do |release_item|
              release_item[:title].length > 0 && (
                release_item[:title].start_with?("feat: ") ||
                release_item[:title].start_with?("fix: ") ||
                release_item[:title].start_with?("perf: ") ||
                release_item[:title].start_with?("security: ")
              )
            end
            .map do |release_item|
              {
                type: release_item[:title].split(":")[0],
                title: release_item[:title].gsub("feat: ", "").gsub("fix: ", "").gsub("perf: ", "").gsub("security: ", ""),
                notes: release_item[:notes]
              }
            end
            .group_by { |release_item| release_item[:type] }
            .flat_map do |type, items|
              [
                case(type)
                when "feat"
                  "## Funcionalidades"
                when "fix"
                  "## Correções de Bugs"
                when "perf"
                  "## Melhorias de Performance"
                when "security"
                  "## Correções de Segurança"
                end, 
                items.map do |item| 
                  has_notes = item[:notes].size > 0
                  notes = has_notes ? "\n#{item[:notes]}" : ""
                  has_notes ? "### #{item[:title]}#{notes}\n" : "- #{item[:title]}"
                end.join("\n")
              ] 
            end.join("\n")

          Actions.lane_context[SharedValues::FL_CHANGELOG] = changelog

          puts("")
          puts(changelog)
          puts("")

          Dir.mkdir("fastlane/metadata/android/pt-BR/changelogs") unless Dir.exist?("fastlane/metadata/android/pt-BR/changelogs")
          File.write("fastlane/metadata/android/pt-BR/changelogs/#{version_code}.txt", changelog)

          changelog
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Simpler changelog generation from git commits'
      end

      def self.details
        'From branch to last tag generate a changelog'
      end

      def self.available_options
        [
        ]
      end

      def self.return_value
        "Returns a String containing your formatted git commits"
      end

      def self.return_type
        :string
      end

      def self.output
        [
          ['GENERATE_CHANGELOG_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.authors
        ['dukex']
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
