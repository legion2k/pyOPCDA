unit methodobject_h;

interface
const
    METH_VARARGS     = $0001; //#define METH_VARARGS  0x0001
    METH_KEYWORDS    = $0002; //#define METH_KEYWORDS 0x0002

    METH_NOARGS      = $0004; //#define METH_NOARGS   0x0004
    METH_O           = $0008; //#define METH_O        0x0008

    METH_CLASS       = $0010; //#define METH_CLASS    0x0010
    METH_STATIC      = $0020; //#define METH_STATIC   0x0020

    METH_COEXIST     = $0040; //#define METH_COEXIST   0x0040

    METH_FASTCALL    = $0080; //#define METH_FASTCALL  0x0080

    METH_STACKLESS   = $0100; //#define METH_STACKLESS 0x0100
    //METH_STACKLESS = $0000; //#define METH_STACKLESS 0x0000

implementation

end.
