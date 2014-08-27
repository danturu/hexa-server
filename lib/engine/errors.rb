module Engine::Errors
  class Error < StandardError; end;
  class OpponentTurnError < Error; end;
  class InvalidTurnError  < Error; end;
end
