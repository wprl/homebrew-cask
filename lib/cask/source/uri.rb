class Cask::Source::URI
  def self.me?(query)
    !!(query.to_s =~ URI.regexp)
  end

  attr_reader :uri

  def initialize(uri)
    @uri = uri
  end

  def load
    HOMEBREW_CACHE_CASKS.mkpath
    path = HOMEBREW_CACHE_CASKS.join(File.basename(uri))
    ohai "Downloading #{uri}"
    odebug "Download target -> #{path.to_s}"
    curl(uri, '-o', path.to_s)
    Cask::Source::PathSlashOptional.new(path).load
  rescue ErrorDuringExecution
    raise CaskUnavailableError, uri
  end

  def to_s
    uri.to_s
  end
end
