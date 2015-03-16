class Status

  PENDING = 'gemeldet'
  RECEIVED = 'offen'
  IN_PROCESS = 'inBearbeitung'
  PROCESSED = 'abgeschlossen'
  REJECTED = 'wirdNichtBearbeitet'

  OPEN = [PENDING, RECEIVED, IN_PROCESS]
  CLOSED = [PROCESSED, REJECTED]

  def self.constant_from_value val
    constants.find{ |name| const_get(name).eql?(val) }.to_s
  end

  def self.open_or_closed val
    OPEN.include?(val) ? "open" : "closed"
  end

end