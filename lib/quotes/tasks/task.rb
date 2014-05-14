module Tasks
  class Task

    def determine_input(input)
      if input.nil?
        build_input_from_seeds
      else
        input
      end
    end

    def determine_file_types(files)
      files.map do |file|
        build_file_type(file)
      end
    end

    def determine_parser(file_type)
      return Services::KindleImporter.new if file_type == :kindle

      Services::WordpressImporter.new
    end

    private

    def build_input_from_seeds
      Dir.glob('./lib/seeds/*').map do |f|
        File.read(f)
      end
    end

    def build_file_type(file)
      return [:kindle, file] if file.start_with?("==")

      [:wordpress, file]
    end

  end
end