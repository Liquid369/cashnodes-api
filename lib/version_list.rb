class VersionList
  def self.call(page=1)
    tot_version = version_count
    {
      version: version(page),
      meta: pagination_meta(page, tot_version)
    }
  end

  private

  PER_PAGE = 10

  def self.base_dir
    ENV['VERSION_BASE_DIR']
  end

  def self.version_paths
    "/root/bitnodes/data/export/a0431619/*"
  end

  def self.version_count
    Dir[version_paths].size
  end

  def self.version(page=1)
    all_version = Dir[version_paths].sort_by{ |f| File.mtime(f) }.reverse
    all_version[((page - 1) * PER_PAGE)..(page * PER_PAGE  - 1)].collect do |f|
      File.basename(f).split('.')[0]
    end
  end

  def self.pagination_meta(page, count=nil)
    len = count || version_count
    pages = (len / PER_PAGE.to_f).ceil
    meta = {page: page, total_pages: pages, total: len}

    if page < pages
      meta[:next] = page + 1
    end

    if page > 1
      meta[:prev] = page - 1
    end
    meta
  end
end

