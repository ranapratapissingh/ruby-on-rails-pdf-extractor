require 'mongo'
require_relative '../webapp/tabula_settings.rb'

Mongo::Logger.logger.level = ::Logger::FATAL
module TabulaMongo
    class Connector
      def initialize
        @client = Mongo::Client.new([TabulaSettings::MONGODB_ENDPOINT+':'+TabulaSettings::MONGODB_PORT],
                           user: TabulaSettings::DB_USER,
                           password: TabulaSettings::DB_PASSWORD)

        @db = Mongo::Database.new(@client, :smeocr)
      end

      def insert(collection_name, documents)
        collection = @db["#{collection_name}"]
        result = collection.find( { 'file_id' => documents[:file_id] } ).first
        if result.nil?
          collection.insert_one(documents)
          puts"---------------> Record insertd into #{collection_name}"
        end
      end

      def insert_or_update(collection_name, documents)
        collection = @db["#{collection_name}"]
        result = collection.find( { 'file_type' => documents[:file_type], 'file_id' => documents[:file_id] } ).first
        if result.nil?
          collection.insert_one(documents)
          puts"---------------> Record insertd into #{collection_name}"
        else
          collection.update_one( {'insert_origin' => documents[:insert_origin], 'file_type' =>   documents[:file_type], 'file_id' =>  documents[:file_id]}, { '$set' => { 'file_path' => documents[:file_path], 'uploaded_at' => documents[:uploaded_at] } }, {:upsert => true} )
          puts"---------------> Record updated into #{collection_name}"
        end
      end
  	end
end