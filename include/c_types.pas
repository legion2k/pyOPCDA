unit c_types;

interface
const
  NULL = nil;
type
  c_chars              = PAnsiChar;
  c_charsAsStr         = AnsiString; // для совместимости с "c_chars"
  c_charsUTF8          = PUTF8Char;
  c_charsAsStrUTF8     = UTF8String; // для совместимости с "c_charsUTF8"
  c_int                = Integer;
  c_void               = pointer;
  c_unsigned_long      = LongWord;
  c_unsigned_long_long = UInt64;
  c_unsigned_int       = NativeUInt;
  c_long               = LongInt;
  c_long_long          = Int64;
  c_char               = Int8;
  c_unsigned_char      = UInt8;
  c_double             = Double;
implementation

end.
