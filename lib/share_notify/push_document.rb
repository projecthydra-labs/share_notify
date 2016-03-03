module ShareNotify
  class PushDocument
    attr_reader :uris, :contributors, :providerUpdatedDateTime, :version, :publisher, :languages, :tags
    attr_accessor :title, :description

    # @param [String] uri that identifies the resource
    def initialize(uri, datetime = nil)
      datetime = (datetime.is_a?(Time) || datetime.is_a?(DateTime)) ? datetime : Time.now
      @uris = ShareUri.new(uri)
      @providerUpdatedDateTime = datetime.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      @contributors = []
    end

    def valid?
      !(title.nil? || contributors.empty?)
    end

    def updated
      @providerUpdatedDateTime
    end

    # @param [DateTime or Time] time object that can be formatted in to the correct representation
    def updated=(time)
      return unless time.respond_to?(:strftime)
      @providerUpdatedDateTime = time.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end

    # @param [String] version identifying the version of the resource
    def version=(version)
      @version = { versionId: version }
    end

    # @param [Hash] contributor containing required keys for description
    def add_contributor(contributor)
      return false unless contributor.keys.include?(:name)
      @contributors << contributor
    end

    # @param [Hash] publisher containing required keys for publisher
    def publisher=(publisher)
      return false unless publisher.keys.include?(:name)
      @publisher = publisher
    end

    def languages=(languages)
      return false unless languages.is_a?(Array)
      @languages = languages
    end

    def tags=(tags)
      return false unless tags.is_a?(Array)
      @tags = tags
    end

    def to_share
      { jsonData: self }
    end

    class ShareUri
      attr_reader :canonicalUri, :providerUris

      def initialize(uri)
        @canonicalUri = uri
        @providerUris = [uri]
      end
    end
  end
end
