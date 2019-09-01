class GetVersion
  def self.call(timestamp, logger=nil)
    path = version_path(timestamp, logger)
    if !path
      return nil
    end

    File.file?(path) ? path : nil
  end

  private

  def self.base_dir
    ENV['VERSION_BASE_DIR']
  end

  def self.version_path(timestamp, logger=nil)
    edir = "/root/bitnodes/data/export/a0431619"
    if !edir
      return nil
    end
    full_path = File.expand_path(File.join(edir, "#{timestamp}.json"))
    if File.dirname(full_path) != edir
      if logger
        logger.warn("bad path: #{full_path}")
      end
      return nil
    end

    full_path
  end
end

