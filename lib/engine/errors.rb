module Engine::Errors
  class InvalidOpponentError < ArgumentError; end;
  class AgainstItselfError < ArgumentError; end;
  class OutOfTurn < StandardError; end;
  class InvalidMovement < StandardError; end;
end
