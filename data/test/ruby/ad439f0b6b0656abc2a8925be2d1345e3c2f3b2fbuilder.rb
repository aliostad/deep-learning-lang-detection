module TrelloFs
  class Builder
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def build
      repository = Repository.new(@config, self)

      # remove old files from the repo
      RepositoryCleaner.new(repository).clean

      boards = TrelloApi.new(repository).boards
      boards.each do |board|
        BoardBuilder.new(repository, board).build
      end
      LabelsBuilder.new(repository).build
      build_readme(repository, boards)

      # remove old attachments
      AttachmentCleaner.new(repository).remove_old_attachments
    end

    def build_readme(repository, boards)
      readme_path = File.join(repository.path, 'README.md')
      File.open(readme_path, 'w') do |file|
        file.write(readme_content(repository, boards))
      end
    end

    def readme_content(repository, boards)
      [
        "# #{repository.title}",
        repository.description,
        boards_content(repository, boards),
        labels_content(repository)
      ].join("\n\n")
    end

    def labels_content(repository)
      return '' unless repository.labels && repository.labels.any?

      repository.labels.values.sort {|a, b| a.name <=> b.name }.
        select {|lbl| lbl.cards.any? }.
        map do |label|
        label_builder = LabelBuilder.new(@repository, label)
        "[`#{label_builder.label_name}`](#{label_builder.relative_path})"
      end.join(' ')
    end

    def boards_content(repository, boards)
      boards.map do |board|
        board_builder = BoardBuilder.new(repository, board)
        [
          "## [#{board.name}](#{board_builder.relative_path}/README.md)",
          board.lists.map do |list|
            list_builder = ListBuilder.new(board_builder, list)
            "  - [#{list_builder.list_name}](#{list_builder.relative_path}/README.md)"
          end.join("\n")
        ].join("\n\n")
      end.join("\n\n")
    end

    def trello_api_board(repository)
      Trello::Board.find(repository.board_id)
    end
  end
end
