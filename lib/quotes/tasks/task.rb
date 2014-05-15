module Tasks
  class Task

    SEED_DIR = './lib/seeds/'

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
      handle_missing_seeds

      Dir.glob('./lib/seeds/*').map do |f|
        File.read(f)
      end
    end

    def build_file_type(file)
      return [:kindle, file] if file.start_with?("==")

      [:wordpress, file]
    end

    def handle_missing_seeds
      msg = "Please put seed files in '#{SEED_DIR}'"
      raise RuntimeError, msg if Dir[SEED_DIR].empty?
    end

  end
end