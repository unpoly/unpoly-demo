module SplitPane
  class MessagesController < ApplicationController

    class Message < Struct.new(:id, :subject, :body, keyword_init: true)
    end

    MESSAGES = (0..49).map do |id|
      Message.new(
        id: id,
        subject: Faker::Lorem.sentence(word_count: 5),
        body: Faker::Lorem.paragraph(sentence_count: rand(3..8)),
        )
    end

    def index
      @messages = MESSAGES
    end

    def show
      @messages = MESSAGES
      @message = MESSAGES[params[:id].to_i]
    end

  end
end
