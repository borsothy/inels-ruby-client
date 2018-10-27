require 'parallel'
require_relative 'client'

module Inels
  class MultiClient
    def initialize(clientdata = [])
      @clients = []
      Parallel.each(clientdata, in_threads: clientdata.count) do |client|
        @clients << Client.new(client['ip'], client['username'], client['password'])
      end
    end

    attr_reader :clients

    def client_for_device(id)
      clients.each do |client|
        return client if client.has_device?(id)
      end
      raise RestClient::NotFound
    end
  end
end
