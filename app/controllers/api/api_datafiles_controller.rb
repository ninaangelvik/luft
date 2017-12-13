class Api::ApiDatafilesController < ApiController

	def create
    begin 
      datafile = Datafile.new do |f| 
        f.filename = generate_filename(params["Filename"])
        f.original_filename = params["Filename"]
        f.filetype = params["ContentType"]
        f.size = params["Size"]
      end
      if datafile.save
        file = StorageBucket.files.new(
          key: "#{datafile.filename}",
          body: params["Contents"],
          public: false
        )
        if file.save
          ProcessInputJob.perform_later(datafile.filename)
          self.response_body = "200 OK"
        end
      end
    rescue => error
      pp error
    	self.response_body = "500 Internal Error"
    end
  end
  
  private

  def generate_filename(filename)
    existing_files = Datafile.where(original_filename: filename)

    unless existing_files.empty?
      ext = File.extname(filename)
      basename = File.basename(filename, ext)

      return "#{basename}(#{existing_files.count})#{ext}"
    else 
      return filename
    end
  end
end