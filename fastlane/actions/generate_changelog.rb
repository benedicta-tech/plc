require 'yaml'
require 'fileutils'

# As notas de versão da Play Store são texto puro: markdown e HTML não são
# renderizados, quebras de linha aparecem exatamente como escritas e o limite
# é de 500 caracteres por idioma (acima disso a API recusa o envio).
module ChangelogFormat
  LIMIT = 500

  SECTIONS = [
    ['feat', 'Novidades'],
    ['fix', 'Correções'],
    ['perf', 'Desempenho'],
    ['security', 'Segurança']
  ].freeze

  CONVENTIONAL = /\A(feat|fix|perf|security):\s+(.+)\z/

  def self.parse(log)
    log.split('$b>').filter_map do |commit|
      title, notes = commit.split('$r>').map(&:strip)
      match = CONVENTIONAL.match(title.to_s)
      next unless match

      { type: match[1], title: match[2], notes: unwrap(notes) }
    end
  end

  # Corpo de commit vem quebrado em 72 colunas e a loja preserva a quebra, o
  # que vira parágrafo torto no celular.
  # ponytail: parágrafos do corpo viram um só, cabe melhor nos 500 caracteres.
  def self.unwrap(text)
    text.to_s.gsub('\n', ' ').gsub(/\s+/, ' ').strip
  end

  # Para caber no limite, primeiro descarta os corpos e só depois itens
  # inteiros, sempre do commit mais antigo para o mais recente.
  def self.build(items)
    kept = items.map(&:dup)
    text = render(kept)
    return [text, []] if text.length <= LIMIT

    kept.reverse_each do |item|
      break if text.length <= LIMIT
      next if item[:notes].empty?

      item[:notes] = ''
      text = render(kept)
    end

    dropped = []
    while text.length > LIMIT && kept.size > 1
      dropped.unshift(kept.pop)
      text = render(kept)
    end

    [text, dropped]
  end

  def self.render(items)
    SECTIONS.filter_map do |type, heading|
      group = items.select { |item| item[:type] == type }
      next if group.empty?

      entries = group.map { |item| entry(item) }
      separator = entries.any? { |text| text.include?("\n") } ? "\n\n" : "\n"
      "#{heading}\n#{entries.join(separator)}"
    end.join("\n\n")
  end

  def self.entry(item)
    item[:notes].empty? ? "• #{item[:title]}" : "• #{item[:title]}\n#{item[:notes]}"
  end
end

# `ruby fastlane/actions/generate_changelog.rb` roda o self-check e sai.
if $PROGRAM_NAME == __FILE__
  items = ChangelogFormat.parse(
    "$b>fix: Liturgia certa$r>Antes o app mostrava\na liturgia salva.\n" \
    "$b>feat: Leitura do dia$r>\n" \
    "$b>chore: mexe no CI$r>não vai para a loja\n"
  )
  raise 'só feat/fix/perf/security entram' unless items.map { |i| i[:type] } == %w[fix feat]
  raise 'corpo precisa virar uma linha só' unless items[0][:notes] == 'Antes o app mostrava a liturgia salva.'

  text, dropped = ChangelogFormat.build(items)
  raise 'markdown não renderiza na loja' if text.include?('#')
  raise 'novidades vêm antes das correções' unless text.index('Novidades') < text.index('Correções')
  raise 'nada deveria ser descartado' unless dropped.empty?
  raise "formato inesperado:\n#{text}" unless text == <<~EXPECTED.strip
    Novidades
    • Leitura do dia

    Correções
    • Liturgia certa
    Antes o app mostrava a liturgia salva.
  EXPECTED

  verbose = (1..6).map { |i| { type: 'fix', title: "Correção número #{i}", notes: 'Explicação do problema com um tamanho parecido com o corpo de um commit real do projeto.' } }
  text, dropped = ChangelogFormat.build(verbose)
  raise 'estourou o limite' if text.length > ChangelogFormat::LIMIT
  raise 'corpos deveriam sair antes dos itens' unless text.include?('Correção número 6') && dropped.empty?
  raise 'corpo do item mais recente deveria ficar' unless text.start_with?("Correções\n• Correção número 1\nExplicação")
  raise 'corpo do item mais antigo deveria sair' unless text.end_with?("\n• Correção número 6")
  raise 'build não pode alterar a lista recebida' if verbose.any? { |item| item[:notes].empty? }

  many = (1..30).map { |i| { type: 'feat', title: "Novidade número #{i} com título longo", notes: '' } }
  text, dropped = ChangelogFormat.build(many)
  raise 'estourou o limite' if text.length > ChangelogFormat::LIMIT
  raise 'itens descartados precisam ser reportados' if dropped.empty?
  raise 'descarta do mais antigo para o mais recente' unless dropped.last[:title] == 'Novidade número 30 com título longo'

  puts 'ok'
  exit
end

module Fastlane
  module Actions
    class GenerateChangelogAction < Action
      def self.run(params)
        pubspec = YAML.load(File.read('pubspec.yaml'))
        _version_name, version_code = pubspec['version'].split('+')

        from = Actions.last_git_tag_name(true, nil)
        UI.verbose("Found the last Git tag: #{from}")
        to = 'HEAD'

        UI.success("Collecting Git commits between #{from} and #{to}")

        log = Actions.git_log_between('format:$b>%s%n$r>%b', from, to, 'include_merges', nil, false, nil)
        changelog, dropped = ChangelogFormat.build(ChangelogFormat.parse(log))

        Actions.lane_context[SharedValues::FL_CHANGELOG] = changelog

        puts('')
        puts(changelog)
        puts('')

        UI.message("Changelog com #{changelog.length} de #{ChangelogFormat::LIMIT} caracteres")

        unless dropped.empty?
          UI.important('Changelog maior que o limite da Play Store, ficaram de fora:')
          dropped.each { |item| UI.important("  #{item[:title]}") }
        end

        if changelog.length > ChangelogFormat::LIMIT
          UI.important("Changelog ainda acima de #{ChangelogFormat::LIMIT} caracteres, edite o arquivo antes do push")
        end

        path = 'fastlane/metadata/android/pt-BR/changelogs'
        FileUtils.mkdir_p(path)
        File.write("#{path}/#{version_code}.txt", changelog)

        changelog
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
        []
      end

      def self.return_value
        'Returns a String containing your formatted git commits'
      end

      def self.return_type
        :string
      end

      def self.output
        []
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