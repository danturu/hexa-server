module Engine::Errors
  class InvalidOpponentError < ArgumentError; end;
  class AgainstItselfError < ArgumentError; end;
  class AlreadyStartedError < StandardError; end;
  class OutOfTurn < StandardError; end;
  class InvalidMovement < StandardError; end;
end